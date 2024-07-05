import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class SecureStorageProvider {
  final FlutterSecureStorage secureStorage;

  SecureStorageProvider(this.secureStorage);

  Future<void> saveToSecureStorage(String key, String value) async {
    try {
      await secureStorage.write(key: key, value: value);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> rmFromSecureStorage(String key) async {
    final wallet = await secureStorage.read(key: key);

    if (wallet == null) {
      throw Exception("Wallet $key doesn't exist");
    }

    await secureStorage.write(key: key, value: null);

    return wallet;
  }

  Future<String> getFromSecureStorage(String key) async {
    final value = await secureStorage.read(key: key);

    if (value == null) {
      throw Exception("Wallet $key doesn't exist");
    }

    return value;
  }
}
