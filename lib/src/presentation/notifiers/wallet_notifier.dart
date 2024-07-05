import 'dart:async';
import 'dart:convert';
import 'package:donationwallet/generated/rust/api/simple.dart';
import 'package:donationwallet/src/data/models/sp_wallet_model.dart';
import 'package:donationwallet/src/domain/usecases/create_wallet_usecase.dart';
import 'package:donationwallet/src/domain/usecases/delete_wallet_usecase.dart';
import 'package:donationwallet/src/domain/usecases/get_wallet_info_usecase.dart';
import 'package:donationwallet/src/domain/usecases/load_raw_wallet_usecase.dart';
import 'package:donationwallet/src/domain/usecases/load_wallet_usecase.dart';
import 'package:donationwallet/src/domain/usecases/save_wallet_usecase.dart';
import 'package:donationwallet/src/domain/usecases/update_wallet_usecase.dart';
import 'package:donationwallet/src/domain/entities/wallet_entity.dart';
import 'package:donationwallet/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class WalletNotifier extends ChangeNotifier {
  final CreateWalletUseCase createWalletUseCase;
  final GetWalletInfoUsecase getWalletInfoUsecase;
  final SaveWalletUseCase saveWalletUseCase;
  final LoadWalletUseCase loadWalletUseCase;
  final DeleteWalletUseCase deleteWalletUseCase;
  final UpdateWalletUseCase updateWalletUseCase;

  WalletNotifier(this.createWalletUseCase, this.getWalletInfoUsecase, this.saveWalletUseCase, this.loadWalletUseCase,
      this.deleteWalletUseCase, this.updateWalletUseCase) {
    _initialize();
  }

  Future<void> _initialize() async {
    await loadWallet();
  }

  WalletEntity? _wallet;
  WalletEntity? get wallet => _wallet;

  String? _mnemonic;
  String? get mnemonic => _mnemonic;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isScanning = false;
  bool get isScanning => _isScanning;

  double _progress = 0.0;
  double get progress => _progress;

  String? _error;
  String? get error => _error;

  void setProgress(double progress) {
    _progress = progress;
  }

  void setBalance(BigInt balance) {
    if (_wallet != null) {
      var wallet = _wallet!;
      wallet.balance = balance;
      _wallet = wallet;
    }
  }

  Future<void> createWallet(String label, String? mnemonic, String? scanKey, String? spendKey, int birthday, String network) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_wallet != null) {
        throw Exception("Wallet alraedy exists");
      }

      final newWallet = await createWalletUseCase(label, mnemonic, scanKey, spendKey, birthday, network);
      await saveWalletUseCase(walletKey, newWallet);
      final wallet = await loadWalletUseCase(walletKey);
      final walletInfo = await getWalletInfoUsecase(walletKey);
      var mutWallet = wallet.toJson();
      mutWallet['address'] = walletInfo.address;
      _wallet = WalletEntity.fromJson(mutWallet);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveWallet(String wallet) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await saveWalletUseCase(walletKey, wallet);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadWallet() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _wallet = await loadWalletUseCase(walletKey);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> rmWallet() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await deleteWalletUseCase(walletKey);
      _wallet = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateWallet() async {
    _isScanning = true;
    _progress = 0.0;
    _error = null;
    notifyListeners();

    try {
      if (_wallet == null) {
        throw Exception("Create wallet first");
      }

      final updated = await updateWalletUseCase(walletKey);
      await saveWalletUseCase(walletKey, updated);
      _wallet = await loadWalletUseCase(walletKey);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isScanning = false;
      _progress = 0.0;
      notifyListeners();
    }
  }
}
