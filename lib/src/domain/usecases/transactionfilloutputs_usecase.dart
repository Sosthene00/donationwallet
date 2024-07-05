import 'package:donationwallet/src/data/repositories/transaction_repository.dart';
import 'package:donationwallet/src/domain/entities/transaction_entity.dart';

class TransactionFilloutputsUsecase {
  final TransactionRepository newtransactionRepository;

  TransactionFilloutputsUsecase(this.newtransactionRepository);

  Future<TransactionEntity> call(TransactionEntity transaction) async {
    try {
      final updated = newtransactionRepository.fillOutputs(transaction);
      transaction.setPsbt = updated;
      return transaction;
    } catch (e) {
      rethrow;
    }
  }
}