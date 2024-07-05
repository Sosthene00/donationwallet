import 'package:donationwallet/src/data/repositories/wallet_repository.dart';

class SaveWalletUseCase {
  final WalletRepository walletRepository;

  SaveWalletUseCase(this.walletRepository);

  Future<void> call(String key, String wallet) async {
    try {
      await walletRepository.saveWallet(key, wallet);
    } catch (e) {
      rethrow;
    }
  }
}
