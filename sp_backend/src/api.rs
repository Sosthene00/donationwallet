use std::collections::HashMap;
use std::sync::{OnceLock, PoisonError};
use std::{str::FromStr, sync::Mutex};

use bip39::rand::RngCore;
use bip39::Mnemonic;
use flutter_rust_bridge::{IntoDart, StreamSink};
use log::info;
use sp_backend::bitcoin::hex::{FromHex, HexToBytesError};
use sp_backend::bitcoin::psbt::{ExtractTxError, PsbtParseError};
use sp_backend::bitcoin::{
    consensus::encode::{serialize_hex, deserialize},
    key::Secp256k1,
    secp256k1::{All, PublicKey, SecretKey},
    Amount, OutPoint, Transaction
};
use sp_backend::silentpayments::secp256k1::rand;
use sp_backend::{
    db::{JsonFile, Storage},
    spclient::{
        derive_keys_from_seed, OutputList, OwnedOutput, Psbt, Recipient,
        SpClient, SpendKey, SpWallet
    },
};

use crate::nakamotoclient;
use crate::{
    logger::{self, LogEntry, LogLevel},
    stream::{self, ScanProgress, SyncStatus},
};
use serde::{Deserialize, Serialize};

const PASSPHRASE: &str = ""; // no passphrase for now

static SECP: OnceLock<Mutex<Secp256k1<All>>> = OnceLock::new();

static WALLET_PATH: OnceLock<Mutex<JsonFile>> = OnceLock::new();

pub struct WalletStatus {
    pub amount: u64,
    pub birthday: u32,
    pub scan_height: u32,
}

type SecretKeyString = String;
type PublicKeyString = String;

#[derive(Deserialize, Serialize)]
pub enum WalletType {
    New,
    Mnemonic(String),
    // scan_sk_hex, spend_sk_hex
    PrivateKeys(SecretKeyString, SecretKeyString),
    // scan_sk_hex, spend_pk_hex
    ReadOnly(SecretKeyString, PublicKeyString),
}

#[derive(Debug)]
pub struct ApiError {
    message: String,
}

impl From<anyhow::Error> for ApiError {
    fn from(value: anyhow::Error) -> Self {
        ApiError {
            message: value.to_string(),
        }
    }
}

impl From<bip39::Error> for ApiError {
    fn from(value: bip39::Error) -> Self {
        ApiError {
            message: value.to_string(),
        }
    }
}

impl From<sp_backend::bitcoin::consensus::encode::Error> for ApiError {
    fn from(value: sp_backend::bitcoin::consensus::encode::Error) -> Self {
        ApiError {
            message: value.to_string(),
        }
    }
}

impl From<PsbtParseError> for ApiError {
    fn from(value: PsbtParseError) -> Self {
        ApiError {
            message: value.to_string(),
        }
    }
}

impl From<HexToBytesError> for ApiError {
    fn from(value: HexToBytesError) -> Self {
        ApiError {
            message: value.to_string(),
        }
    }
}

impl From<ExtractTxError> for ApiError {
    fn from(value: ExtractTxError) -> Self {
        ApiError {
            message: value.to_string(),
        }
    }
}

impl<T> From<PoisonError<T>> for ApiError {
    fn from(value: PoisonError<T>) -> Self {
        ApiError {
            message: value.to_string(),
        }
    }
}

impl From<sp_backend::bitcoin::secp256k1::Error> for ApiError {
    fn from(value: sp_backend::bitcoin::secp256k1::Error) -> Self {
        ApiError {
            message: value.to_string(),
        }
    }
}

type ApiResult<T: IntoDart> = Result<T, ApiError>;

pub fn create_log_stream(s: StreamSink<LogEntry>, level: LogLevel, log_dependencies: bool) {
    logger::init_logger(level.into(), log_dependencies);
    logger::FlutterLogger::set_stream_sink(s);
}
pub fn create_sync_stream(s: StreamSink<SyncStatus>) {
    stream::create_sync_stream(s);
}
pub fn create_scan_progress_stream(s: StreamSink<ScanProgress>) {
    stream::create_scan_progress_stream(s);
}
pub fn create_amount_stream(s: StreamSink<u64>) {
    stream::create_amount_stream(s);
}
pub fn create_nakamoto_run_stream(s: StreamSink<bool>) {
    stream::create_nakamoto_run_stream(s);
}

pub(crate) fn get_secp() -> &'static Mutex<Secp256k1<All>> {
    SECP.get_or_init(|| Mutex::new(Secp256k1::new()))
}

pub fn setup(
    label: String,
    files_dir: String,
    wallet_type: WalletType,
    birthday: u32,
    is_testnet: bool,
) -> ApiResult<()> {
    let wallet: Result<SpWallet, anyhow::Error> = JsonFile::new(&files_dir, &label).load();
    if wallet.is_ok() {
        return Err(ApiError { message: label });
    }; // If the wallet already exists we just send the label as an error message

    let mnemonic: Option<String>;
    let scan_key: SecretKey;
    let spend_key: SpendKey;
    // TODO lot of repetition here
    match wallet_type {
        WalletType::New => {
            // We create a new wallet and return the new mnemonic
            let m = Mnemonic::generate(12)?;
            let seed = m.to_seed(PASSPHRASE);
            let (scan_sk, spend_sk) = derive_keys_from_seed(&seed, is_testnet)?;
            scan_key = scan_sk;
            spend_key = SpendKey::Secret(spend_sk);
            mnemonic = Some(m.to_string());
        }
        WalletType::Mnemonic(words) => {
            // We restore from seed
            let m = Mnemonic::from_str(&words)?;
            let seed = m.to_seed(PASSPHRASE);
            let (scan_sk, spend_sk) = derive_keys_from_seed(&seed, is_testnet)?;
            scan_key = scan_sk;
            spend_key = SpendKey::Secret(spend_sk);
            mnemonic = Some(m.to_string());
        }
        WalletType::PrivateKeys(scan_sk_hex, spend_sk_hex) => {
            // We directly restore with the keys
            scan_key = SecretKey::from_str(&scan_sk_hex)?;
            spend_key = SpendKey::Secret(SecretKey::from_str(&spend_sk_hex)?);
            mnemonic = None;
        }
        WalletType::ReadOnly(scan_sk_hex, spend_pk_hex) => {
            // We're only able to find payments but not to spend it
            scan_key = SecretKey::from_str(&scan_sk_hex)?;
            spend_key = SpendKey::Public(PublicKey::from_str(&spend_pk_hex)?);
            mnemonic = None;
        }
    }
    let sp_client = SpClient::new(label, scan_key, spend_key, mnemonic, is_testnet)?;
    let secp = get_secp().lock()?;
    let sp_outputs = OutputList::new(scan_key.public_key(&secp), spend_key.into(), birthday);
    let wallet = SpWallet::new(sp_client, sp_outputs)?;
    let file = JsonFile::new(&files_dir, &label);
    file.save(&wallet)?;
    Ok(())
}

/// Change wallet birthday
/// Since this method doesn't touch the known outputs
/// the caller is responsible for resetting the wallet to its new birthday  
pub fn change_birthday(path: String, label: String, birthday: u32) -> ApiResult<()> {
    let mut wallet: SpWallet = JsonFile::new(&path, &label).load()?;

    let outputs = wallet.get_mut_outputs();

    outputs.set_birthday(birthday);

    JsonFile::new(&path, &label).save(&wallet)?;

    Ok(())
}

/// Reset the last_scan of the wallet to its birthday, removing all outpoints
pub fn reset_wallet(path: String, label: String) -> ApiResult<()> {
    let mut wallet: SpWallet = JsonFile::new(&path, &label).load()?;

    let outputs = wallet.get_mut_outputs();

    outputs.reset_to_birthday();

    JsonFile::new(&path, &label).save(&wallet)?;

    Ok(())
}

pub fn remove_wallet(path: String, label: String) -> ApiResult<()> {
    let _ = JsonFile::new(&path, &label).rm()?;

    Ok(())
}

pub fn sync_blockchain() -> ApiResult<()> {
    let (handle, join_handle) = nakamotoclient::start_nakamoto_client()?;

    info!("Nakamoto started");
    let res = nakamotoclient::sync_blockchain(handle.clone());

    nakamotoclient::stop_nakamoto_client(handle, join_handle)?;

    res.map_err(|e| <ApiError>::from(e))
}

pub fn scan_to_tip(path: String, label: String) -> ApiResult<()> {
    let (handle, join_handle) = nakamotoclient::start_nakamoto_client()?;
    info!("Nakamoto started");

    let mut wallet: SpWallet = JsonFile::new(&path, &label).load()?;
    let res = nakamotoclient::scan_blocks(handle.clone(), 0, &mut wallet);

    JsonFile::new(&path, &label).save(&wallet)?;

    nakamotoclient::stop_nakamoto_client(handle, join_handle)?;

    res.map_err(|e| <ApiError>::from(e))
}

pub fn get_wallet_info(path: String, label: String) -> ApiResult<WalletStatus> {
    let mut wallet: SpWallet = JsonFile::new(&path, &label).load()?;

    let outputs = wallet.get_mut_outputs();
    let scan_height = outputs.get_last_scan();
    let birthday = outputs.get_birthday();
    let amount = outputs.get_balance().to_sat();

    Ok(WalletStatus {
        amount,
        birthday,
        scan_height,
    })
}

pub fn get_receiving_address(path: String, label: String) -> ApiResult<String> {
    let mut wallet: SpWallet = JsonFile::new(&path, &label).load()?;

    Ok(wallet.get_mut_client().get_receiving_address())
}

pub fn get_spendable_outputs(
    path: String,
    label: String,
) -> ApiResult<HashMap<OutPoint, OwnedOutput>> {
    let mut wallet: SpWallet = JsonFile::new(&path, &label).load()?;
    Ok(wallet.get_mut_outputs().to_spendable_list())
}

pub fn get_outputs(path: String, label: String) -> ApiResult<HashMap<OutPoint, OwnedOutput>> {
    let mut wallet: SpWallet = JsonFile::new(&path, &label).load()?;

    Ok(wallet.get_mut_outputs().to_outpoints_list())
}

pub fn create_new_psbt(
    label: String,
    path: String,
    inputs: HashMap<OutPoint, OwnedOutput>,
    recipients: Vec<Recipient>,
) -> ApiResult<String> {
    let mut wallet: SpWallet = JsonFile::new(&path, &label).load()?;

    let psbt = wallet
        .get_mut_client()
        .create_new_psbt(inputs, recipients, None)?;

    Ok(psbt.to_string())
}

// payer is an address, either Silent Payment or not
pub fn add_fee_for_fee_rate(psbt: String, fee_rate: u64, payer: String) -> ApiResult<String> {
    let mut psbt = Psbt::from_str(&psbt)?;

    SpClient::set_fees(&mut psbt, Amount::from_sat(fee_rate), payer)?;

    Ok(psbt.to_string())
}

pub fn fill_sp_outputs(path: String, label: String, psbt: String) -> ApiResult<String> {
    let mut wallet: SpWallet = JsonFile::new(&path, &label).load()?;

    let mut psbt = Psbt::from_str(&psbt)?;

    wallet.get_mut_client().fill_sp_outputs(&mut psbt)?;

    Ok(psbt.to_string())
}

pub fn sign_psbt(path: String, label: String, psbt: String, finalize: bool) -> ApiResult<String> {
    let mut wallet: SpWallet = JsonFile::new(&path, &label).load()?;

    let mut psbt = Psbt::from_str(&psbt)?;

    let mut aux_rand = [0u8; 32];
    rand::thread_rng().fill_bytes(aux_rand.as_mut_slice());

    let mut signed = wallet
        .get_mut_client()
        .sign_psbt(psbt, &aux_rand)?;

    if finalize {
        SpClient::finalize_psbt(&mut signed)?;
    }

    Ok(signed.to_string())
}

pub fn extract_tx_from_psbt(psbt: String) -> ApiResult<String> {
    let psbt = Psbt::from_str(&psbt)?;

    let final_tx = psbt.extract_tx()?;
    Ok(serialize_hex(&final_tx))
}

pub fn broadcast_tx(tx: String) -> ApiResult<String> {
    let (handle, join_handle) =
        nakamotoclient::start_nakamoto_client()?;
    info!("Nakamoto started");

    let res = nakamotoclient::broadcast_transaction(handle.clone(), tx);

    nakamotoclient::stop_nakamoto_client(handle, join_handle)?;

    res.map_err(|e| e.into())
}

pub fn mark_transaction_inputs_as_spent(
    path: String,
    label: String,
    tx_hex: String,
) -> ApiResult<()> {
    let mut wallet: SpWallet = JsonFile::new(&path, &label).load()?;

    // get the inputs of the transaction
    let tx: Transaction = deserialize(&Vec::from_hex(&tx_hex)?)?;

    for input in tx.input {
        if let Ok(owned) = wallet.get_mut_outputs().get_outpoint(input.previous_output) {
            wallet
                .get_mut_outputs()
                .mark_spent(owned.0, tx.txid(), true)?;
        }
    }

    Ok(())
}

pub fn show_mnemonic(path: String, label: String) -> ApiResult<Option<String>> {
    let mut wallet: SpWallet = JsonFile::new(&path, &label).load()?;

    let mnemonic = wallet.get_mut_client().get_mnemonic();

    Ok(mnemonic)
}
