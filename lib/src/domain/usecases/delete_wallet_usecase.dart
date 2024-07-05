import 'package:donationwallet/src/data/repositories/wallet_repository.dart';

class DeleteWalletUseCase {
  final WalletRepository walletRepository;

  DeleteWalletUseCase(this.walletRepository);

  Future<void> call(String label) async {
    try {
      await walletRepository.rmWallet(label);
    } catch (e) {
      rethrow;
    }
  }
}
