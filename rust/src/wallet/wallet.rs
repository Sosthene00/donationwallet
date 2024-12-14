use std::collections::HashMap;
use std::sync::atomic::AtomicBool;

use serde::{Deserialize, Serialize};
use sp_client::bitcoin::absolute::Height;
use sp_client::bitcoin::OutPoint;
use sp_client::bitcoin::{Amount, Txid};

use anyhow::{Error, Result};

use sp_client::{OutputSpendStatus, OwnedOutput, Recipient, SpClient};

use super::recorded::{RecordedTransaction, RecordedTransactionOutgoing};

type WalletFingerprint = [u8; 8];

use lazy_static::lazy_static;

// AtomicBool to control scanning state
lazy_static! {
    pub static ref KEEP_SCANNING: AtomicBool = AtomicBool::new(true);
}

// Main wallet structure
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SpWallet {
    pub client: SpClient, // Client instance
    pub wallet_fingerprint: WalletFingerprint, // Unique identifier for the wallet
    pub tx_history: Vec<RecordedTransaction>, // Transaction history
    pub birthday: Height, // Block height when the wallet was created
    pub last_scan: Height, // Last scanned block height
    pub outputs: HashMap<OutPoint, OwnedOutput>, // Map of outputs
}

impl SpWallet {
    // Constructor for SpWallet
    pub fn new(client: SpClient, birthday: u32) -> Result<Self> {
        let wallet_fingerprint = client.get_client_fingerprint()?; // Get wallet fingerprint
        let birthday = Height::from_consensus(birthday)?; // Convert birthday to Height
        let last_scan = birthday; // Initialize last_scan with birthday
        let tx_history = vec![]; // Initialize empty transaction history
        let outputs = HashMap::new(); // Initialize empty outputs map

        Ok(Self {
            client,
            birthday,
            wallet_fingerprint,
            last_scan,
            tx_history,
            outputs,
        })
    }

    // Calculate the wallet balance
    pub fn get_balance(&self) -> Amount {
        self.outputs
            .iter()
            .filter(|(_, o)| o.spend_status == OutputSpendStatus::Unspent) // Filter unspent outputs
            .fold(Amount::from_sat(0), |acc, x| acc + x.1.amount) // Sum the amounts
    }

    // Reset wallet state to a specific block height
    fn reset_to_height(&mut self, blkheight: Height) {
        // reset known outputs to height
        self.outputs.retain(|_, o| o.blockheight < blkheight);

        // reset tx history to height
        self.tx_history.retain(|tx| match tx {
            RecordedTransaction::Incoming(incoming) => {
                incoming.confirmed_at.is_some_and(|x| x < blkheight)
            }
            RecordedTransaction::Outgoing(outgoing) => {
                outgoing.confirmed_at.is_some_and(|x| x < blkheight)
            }
        });
    }

    // Reset wallet state to its birthday
    pub fn reset_to_birthday(&mut self) {
        self.reset_to_height(self.birthday); // Reset to birthday height
        self.last_scan = self.birthday; // Update last_scan to birthday
    }

    // Mark an output as spent
    pub fn mark_spent(
        &mut self,
        outpoint: OutPoint,
        spending_tx: Txid,
        force_update: bool,
    ) -> Result<()> {
        let output = self
            .outputs
            .get_mut(&outpoint)
            .ok_or(Error::msg("Outpoint not in list"))?; // Get the output or return an error

        match &output.spend_status {
            OutputSpendStatus::Unspent => {
                let tx_hex = spending_tx.to_string();
                output.spend_status = OutputSpendStatus::Spent(tx_hex); // Mark as spent
                Ok(())
            }
            OutputSpendStatus::Spent(tx_hex) => {
                if force_update {
                    let tx_hex = spending_tx.to_string();
                    output.spend_status = OutputSpendStatus::Spent(tx_hex); // Force update to spent
                    Ok(())
                } else {
                    Err(Error::msg(format!(
                        "Output already spent by transaction {}",
                        tx_hex
                    )))
                }
            }
            OutputSpendStatus::Mined(block) => Err(Error::msg(format!(
                "Output already mined in block {}",
                block
            ))),
        }
    }

    // Record an outgoing transaction
    pub fn record_outgoing_transaction(
        &mut self,
        txid: Txid,
        spent_outpoints: Vec<OutPoint>,
        recipients: Vec<Recipient>,
        change: Amount,
    ) {
        self.tx_history
            .push(RecordedTransaction::Outgoing(RecordedTransactionOutgoing {
                txid,
                spent_outpoints,
                recipients,
                confirmed_at: None, // Transaction not yet confirmed
                change,
            }))
    }
}
