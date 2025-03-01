import 'dart:async';
import 'package:danawallet/constants.dart';
import 'package:danawallet/data/models/recipient_form_filled.dart';
import 'package:danawallet/data/models/recommended_fee_model.dart';
import 'package:danawallet/generated/rust/api/stream.dart';
import 'package:danawallet/generated/rust/api/structs.dart';
import 'package:danawallet/generated/rust/api/wallet.dart';
import 'package:danawallet/repositories/mempool_api_repository.dart';
import 'package:danawallet/repositories/wallet_repository.dart';
import 'package:flutter/material.dart';

class WalletState extends ChangeNotifier {
  final walletRepository = WalletRepository();
  late BigInt amount;
  late int birthday;
  late int lastScan;
  late Network _network;
  late String address;
  late Map<String, ApiOwnedOutput> ownedOutputs;
  late List<ApiRecordedTransaction> txHistory;

  late StreamSubscription scanResultSubscription;

  WalletState();

  Network get network => _network;
  set network(Network value) {
    _network = value;
    notifyListeners();
  }

  Future<bool> initialize() async {
    await _initStreams();

    // we check if wallet str is present in database
    final walletStr = await walletRepository.readWalletBlob();

    // if not present, we have no wallet and return false
    if (walletStr == null) {
      return false;
    }

    // We try to load the wallet data blob.
    // This may fail if we make a change to the wallet data struct.
    // This case should crash the app, rather than continue.
    // If we continue, we risk the user accidentally
    // deleting their seed phrase.
    try {
      await _updateWalletStatus(walletStr);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _initStreams() async {
    scanResultSubscription = createScanResultStream().listen(((event) async {
      await saveWalletToSecureStorage(event.updatedWallet);
      try {
        await _updateWalletStatus(event.updatedWallet);
      } catch (e) {
        rethrow;
      }
      notifyListeners();
    }));
  }

  @override
  void dispose() {
    scanResultSubscription.cancel();
    super.dispose();
  }

  Future<void> reset() async {
    await walletRepository.reset();
  }

  Future<void> saveWalletToSecureStorage(String wallet) async {
    await walletRepository.saveWalletBlob(wallet);
  }

  Future<void> saveSeedPhraseToSecureStorage(String seedphrase) async {
    await walletRepository.saveSeedPhrase(seedphrase);
  }

  Future<void> saveNetwork(Network network) async {
    await walletRepository.saveNetwork(network);
  }

  Future<String> getWalletFromSecureStorage() async {
    final wallet = await walletRepository.readWalletBlob();
    if (wallet != null) {
      return wallet;
    } else {
      throw Exception("No wallet in storage");
    }
  }

  Future<String?> getSeedPhrase() async {
    return await walletRepository.readSeedPhrase();
  }

  Future<void> updateWalletStatus() async {
    try {
      final wallet = await getWalletFromSecureStorage();
      _updateWalletStatus(wallet);
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> _updateWalletStatus(String wallet) async {
    ApiWalletStatus walletInfo;
    try {
      walletInfo = getWalletInfo(encodedWallet: wallet);
    } catch (e) {
      rethrow;
    }

    BigInt totalAmount = walletInfo.balance;

    for (ApiRecordedTransaction tx in walletInfo.txHistory) {
      switch (tx) {
        case ApiRecordedTransaction_Outgoing(:final field0):
          if (field0.confirmedAt == null) {
            // while an outgoing transaction is not yet confirmed, we add the change outputs manually
            totalAmount += field0.change.field0;
          }
        default:
      }
    }

    // read network from wallet repository
    // if network is not in storage, user may be using an old wallet where
    // it was stored in the wallet blob, so  try reading from there instead
    final network = await walletRepository.readNetwork();
    if (network != null) {
      this.network = network;
    } else {
      this.network = Network.fromBitcoinNetwork(walletInfo.network!);
    }

    address = walletInfo.address;
    amount = totalAmount;
    birthday = walletInfo.birthday;
    lastScan = walletInfo.lastScan;
    ownedOutputs = walletInfo.outputs;
    txHistory = walletInfo.txHistory;
  }

  Map<String, ApiOwnedOutput> getSpendableOutputs() {
    var spendable = ownedOutputs.entries.where((element) =>
        element.value.spendStatus == const ApiOutputSpendStatus.unspent());
    return Map.fromEntries(spendable);
  }

  Future<void> updateWalletBirthday(int birthday) async {
    final wallet = await getWalletFromSecureStorage();
    final updatedWallet =
        changeBirthday(encodedWallet: wallet, birthday: birthday);
    await saveWalletToSecureStorage(updatedWallet);
    await updateWalletStatus();
  }

  Future<String> getChangeAddress() async {
    final wallet = await getWalletFromSecureStorage();

    final walletInfo = getWalletInfo(encodedWallet: wallet);

    return walletInfo.changeAddress;
  }

  Future<RecommendedFeeResponse> getCurrentFeeRates() async {
    final mempoolApiRepository = MempoolApiRepository(network: network);
    final response = await mempoolApiRepository.getCurrentFeeRate();
    return response;
  }

  Future<ApiSilentPaymentUnsignedTransaction> createUnsignedTxToThisRecipient(
      RecipientFormFilled recipient) async {
    final wallet = await getWalletFromSecureStorage();

    final unspentOutputs = Map.fromEntries(
      ownedOutputs.entries.where((entry) =>
          entry.value.spendStatus == const ApiOutputSpendStatus.unspent()),
    );
    final bitcoinNetwork = network.toBitcoinNetwork;

    if (recipient.amount.field0 < amount - BigInt.from(546)) {
      return createNewTransaction(
          encodedWallet: wallet,
          apiOutputs: unspentOutputs,
          apiRecipients: [
            ApiRecipient(
                address: recipient.recipientAddress, amount: recipient.amount)
          ],
          feerate: recipient.feerate.toDouble(),
          network: bitcoinNetwork);
    } else {
      return createDrainTransaction(
          encodedWallet: wallet,
          apiOutputs: unspentOutputs,
          wipeAddress: recipient.recipientAddress,
          feerate: recipient.feerate.toDouble(),
          network: bitcoinNetwork);
    }
  }

  Future<void> signAndBroadcastUnsignedTx(
      ApiSilentPaymentUnsignedTransaction unsignedTx) async {
    final wallet = await getWalletFromSecureStorage();

    final walletInfo = getWalletInfo(encodedWallet: wallet);

    final selectedOutputs = unsignedTx.selectedUtxos;

    final changeValue =
        unsignedTx.getChangeAmount(changeAddress: walletInfo.changeAddress);

    final recipients =
        unsignedTx.getRecipients(changeAddress: walletInfo.changeAddress);

    final finalizedTx = finalizeTransaction(unsignedTransaction: unsignedTx);

    final signedTx = signTransaction(
        encodedWallet: wallet, unsignedTransaction: finalizedTx);
    final txid =
        await broadcastTx(tx: signedTx, network: network.toBitcoinNetwork);

    List<String> selectedOutpoints =
        selectedOutputs.map((tuple) => tuple.$1).toList();

    final markedAsSpentWallet = markOutpointsSpent(
        encodedWallet: wallet, spentBy: txid, spent: selectedOutpoints);

    final updatedWallet = addOutgoingTxToHistory(
        encodedWallet: markedAsSpentWallet,
        txid: txid,
        spentOutpoints: selectedOutpoints,
        recipients: recipients,
        change: changeValue);

    // save the updated wallet
    saveWalletToSecureStorage(updatedWallet);
    await updateWalletStatus();

    return;
  }
}
