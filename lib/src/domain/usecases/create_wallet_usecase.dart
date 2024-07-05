import 'package:donationwallet/src/data/repositories/wallet_repository.dart';
import 'package:logger/logger.dart';

class CreateWalletUseCase {
  final WalletRepository walletRepository;

  CreateWalletUseCase(this.walletRepository);

  Future<String> call(String label, String? mnemonic, String? scanKey, String? spendKey, int birthday, String network) async {
    try {
      final wallet = await walletRepository.createWallet(label, mnemonic, scanKey, spendKey, birthday, network);
      return wallet;
    } catch (e) {
      rethrow;
    }
  }
}
