import 'dart:convert';

import 'package:donationwallet/generated/rust/api/simple.dart';
import 'package:donationwallet/src/data/providers/rust_api.dart';
import 'package:donationwallet/src/data/providers/secure_storage.dart';
import 'package:donationwallet/src/domain/entities/wallet_entity.dart';
import 'package:donationwallet/src/data/models/sp_wallet_model.dart';
import 'package:logger/logger.dart';

class WalletRepository {
  final RustApi rustApi;
  final SecureStorageProvider secureStorageProvider;

  WalletRepository(this.secureStorageProvider, this.rustApi);

  WalletEntity convertSpWalletToWalletEntity(SpWallet spWallet) {
    return WalletEntity(
      label: spWallet.client.label,
      address: "", // we need to add it later
      network: spWallet.client.spReceiver.network,
      balance: BigInt.zero, 
      birthday: spWallet.outputs.birthday,
      lastScan: spWallet.outputs.lastScan,
      ownedOutputs: spWallet.outputs.outputs,
    );
  }

  Future<String> createWallet(String label, String? mnemonic, String? scanKey, String? spendKey, int birthday, String network) async {
    try {
      final wallet = await rustApi.createNewWalletApi(label, mnemonic, scanKey, spendKey, birthday, network);
      return wallet;
    } catch (e) {
      rethrow;
    }
  } 

  Future<String> updateWallet(String key) async {
    try {
      final wallet = await secureStorageProvider.getFromSecureStorage(key);
      final updated = await rustApi.updateWalletApi(wallet);
      return updated;
    } catch (e) {
      rethrow;
    }
  }

  Future<WalletStatus> getWalletInfo(String key) async {
    try {
      final wallet = await secureStorageProvider.getFromSecureStorage(key);
      return await rustApi.retrieveWalletInfo(wallet);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveWallet(String label, String wallet) async {
    try {
      await secureStorageProvider.saveToSecureStorage(
          label, wallet);
    } catch (e) {
      throw Exception("Failed to save wallet to secure storage");
    }
  }

  Future<WalletEntity> getWallet(String label) async {
    try {
      final json =
          await secureStorageProvider.getFromSecureStorage(label);
      final spWallet =
          SpWallet.fromJson(jsonDecode(json) as Map<String, dynamic>);
      return convertSpWalletToWalletEntity(spWallet);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getRawWallet(String label) async {
    try {
      return await secureStorageProvider.getFromSecureStorage(label);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> rmWallet(String label) async {
    try {
      await secureStorageProvider.rmFromSecureStorage(label);
    } catch (e) {
      rethrow;
    }
  }
}
