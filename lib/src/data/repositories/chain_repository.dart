import 'package:donationwallet/src/data/providers/chain_api.dart';
import 'package:logger/logger.dart';

class ChainRepository {
  final ChainApiProvider chainApiProvider;

  ChainRepository(this.chainApiProvider);

  Future<int> getChainTip() async {
    try {
      final tip = await chainApiProvider.getChainTipFromApi();
      return tip;
    } catch (e) {
      rethrow;
    }
  }
}
