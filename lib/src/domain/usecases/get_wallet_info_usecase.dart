import 'package:donationwallet/generated/rust/api/simple.dart';
import 'package:donationwallet/src/data/repositories/wallet_repository.dart';
import 'package:logger/logger.dart';

class GetWalletInfoUsecase {
  final WalletRepository walletRepository;

  GetWalletInfoUsecase(this.walletRepository);

  Future<WalletStatus> call(String key) async {
    try {
      return await walletRepository.getWalletInfo(key);
    } catch (e) {
      rethrow;
    }
  }
}
