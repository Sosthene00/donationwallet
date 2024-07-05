import 'package:donationwallet/src/data/providers/rust_api.dart';
import 'package:donationwallet/src/domain/entities/transaction_entity.dart';

class TransactionRepository {
  final RustApi rustApi;

  TransactionRepository(this.rustApi);

  String createNewPsbt(TransactionEntity transaction) {
    if (transaction.finalTx != null) {
      throw Exception("Transaction already finalized");
    } else if (transaction.psbt != null) {
      throw Exception("Psbt already existing");
    }

    return rustApi.createNewPsbtApi(transaction.getSpWallet, transaction.getSelectedOutputs, transaction.getRecipients);
  }

  String udpateFees(TransactionEntity transaction) {
    if (transaction.finalTx != null) {
      throw Exception("Transaction already finalized");
    } else if (transaction.psbt == null) {
      throw Exception("No psbt");
    }

    try {
      return rustApi.updateFeesApi(transaction.psbt!, transaction.getFeeRate, transaction.getFeePayer);
    } catch (e) {
      rethrow;
    }
  }

  String fillOutputs(TransactionEntity transaction) {
    if (transaction.finalTx != null) {
      throw Exception("Transaction already finalized");
    } else if (transaction.psbt == null) {
      throw Exception("No psbt");
    }

    try {
      return rustApi.fillOutputsApi(transaction.spWallet, transaction.psbt!);
    } catch (e) {
      rethrow;
    }
  }
  
  String signPsbt(TransactionEntity transaction) {
    if (transaction.finalTx != null) {
      throw Exception("Transaction already finalized");
    } else if (transaction.psbt == null) {
      throw Exception("No psbt");
    }

    try {
      return rustApi.signPsbtApi(transaction.spWallet, transaction.psbt!, true);
    } catch (e) {
      rethrow;
    }
  }
}
