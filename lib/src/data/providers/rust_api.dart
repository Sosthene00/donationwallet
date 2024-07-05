import 'package:donationwallet/generated/rust/api/simple.dart';
import 'package:logger/logger.dart';

class RustApi {
  RustApi();

  Future<String> createNewWalletApi(String label, String? mnemonic, String? scanKey, String? spendKey, int birthday, String network) async {
    try {
      return await setup(
        label: label,
        mnemonic: mnemonic,
        scanKey: scanKey,
        spendKey: spendKey,
        birthday: birthday,
        network: network,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updateWalletApi(String wallet) async {
    try {
      final updated = await scanToTip(encodedWallet: wallet);
      return updated;
    } catch (e) {
      rethrow;
    }
  }

  Future<WalletStatus> retrieveWalletInfo(String wallet) async {
    try {
      return getWalletInfo(encodedWallet: wallet);
    } catch (e) {
      rethrow;
    }
  }

  String createNewPsbtApi(String encodedWallet, Map<String, OwnedOutput> inputs,
      List<Recipient> recipients) {
    try {
      return createNewPsbt(
          encodedWallet: encodedWallet, inputs: inputs, recipients: recipients);
    } catch (e) {
      rethrow;
    }
  }

  String updateFeesApi(String psbt, int feeRate, String payer) {
    try {
      return addFeeForFeeRate(psbt: psbt, feeRate: feeRate, payer: payer);
    } catch (e) {
      rethrow;
    }
  }

  String fillOutputsApi(String encodedWallet, String psbt) {
    try {
      return fillSpOutputs(encodedWallet: encodedWallet, psbt: psbt);
    } catch (e) {
      rethrow;
    }
  }

  String signPsbtApi(String encodedWallet, String psbt, bool finalize) {
    try {
      return signPsbt(encodedWallet: encodedWallet, psbt: psbt, finalize: finalize);
    } catch (e) {
      rethrow;
    }
  }
}
