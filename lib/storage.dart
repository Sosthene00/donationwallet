import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:donationwallet/wallet.dart';

class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  SecureStorageService._internal();

  factory SecureStorageService() {
    return _instance;
  }

  Future<void> resetWallet() async {
    await _secureStorage.delete(key: label);
  }

  Future<bool> isInitialized() async {
    final wallet = await _secureStorage.read(key: label);
    return (wallet != null);
  }

  Future<String?> read({required String key}) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> write({required String key, required String value}) async {
    return await _secureStorage.write(key: key, value: value);
  }
}
