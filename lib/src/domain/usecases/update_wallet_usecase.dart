import 'package:donationwallet/src/data/repositories/wallet_repository.dart';
import 'package:logger/logger.dart';

class UpdateWalletUseCase {
  final WalletRepository walletRepository;

  UpdateWalletUseCase(this.walletRepository);

  Future<String> call(String key) async {
    try {
      return await walletRepository.updateWallet(key);
    } catch (e) {
      rethrow;
    }
  }
}
