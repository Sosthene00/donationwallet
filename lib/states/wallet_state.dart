import 'dart:async';
import 'package:donationwallet/rust/api/stream.dart';
import 'package:donationwallet/rust/api/structs.dart';
import 'package:donationwallet/rust/api/wallet.dart';
import 'package:donationwallet/rust/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WalletState extends ChangeNotifier {
  final String label = "default";
  BigInt amount = BigInt.from(0);
  int birthday = 0;
  int lastScan = 0;
  double progress = 0.0;
  bool scanning = false;
  String _network = '';
  bool walletLoaded = false;
  String address = "";
  Map<String, OwnedOutput> ownedOutputs = {};
  List<RecordedTransaction> txHistory = List.empty(growable: true);
  final secureStorage = const FlutterSecureStorage();

  late StreamSubscription logStreamSubscription;
  late StreamSubscription scanProgressSubscription;
  late StreamSubscription amountStreamSubscription;
  late StreamSubscription syncStreamSubscription;

  WalletState();

  String get network => _network;
  set network(String value) {
    _network = value;
    notifyListeners();
  }

  Future<void> initialize() async {
    try {
      await _initStreams();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _initStreams() async {
    logStreamSubscription =
        createLogStream(level: LogLevel.debug, logDependencies: true)
            .listen((event) {
      print('${event.level} (${event.tag}): ${event.msg}');
      notifyListeners();
    });

    scanProgressSubscription = createScanProgressStream().listen(((event) {
      int start = event.start;
      int current = event.current;
      int end = event.end;
      double scanned = (current - start).toDouble();
      double total = (end - start).toDouble();
      double progress = scanned / total;
      if (current == end) {
        progress = 0.0;
        scanning = false;
      }
      this.progress = progress;
      lastScan = current;

      notifyListeners();
    }));

    amountStreamSubscription = createAmountStream().listen((event) {
      amount = event;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    logStreamSubscription.cancel();
    scanProgressSubscription.cancel();
    amountStreamSubscription.cancel();
    syncStreamSubscription.cancel();
    super.dispose();
  }

  Future<void> reset() async {
    amount = BigInt.zero;
    network = "";
    birthday = 0;
    lastScan = 0;
    progress = 0.0;
    scanning = false;
    walletLoaded = false;
    address = "";
    ownedOutputs = {};
    txHistory = List.empty(growable: true);

    notifyListeners();
  }

  Future<void> saveWalletToSecureStorage(String wallet) async {
    await secureStorage.write(key: label, value: wallet);
  }

  Future<void> rmWalletFromSecureStorage() async {
    await secureStorage.write(key: label, value: null);
  }

  Future<String> getWalletFromSecureStorage() async {
    final wallet = await secureStorage.read(key: label);
    if (wallet != null) {
      return wallet;
    } else {
      throw Exception("No wallet in storage");
    }
  }

  Future<void> updateWalletStatus() async {
    WalletStatus walletInfo;
    try {
      final wallet = await getWalletFromSecureStorage();
      walletInfo = getWalletInfo(encodedWallet: wallet);
    } catch (e) {
      rethrow;
    }
    address = walletInfo.address;
    amount = walletInfo.balance;
    birthday = walletInfo.birthday;
    lastScan = walletInfo.lastScan;
    ownedOutputs = walletInfo.outputs;
    txHistory = walletInfo.txHistory;
    network = walletInfo.network;
    notifyListeners();
  }

  Map<String, OwnedOutput> getSpendableOutputs() {
    var spendable = ownedOutputs.entries.where((element) =>
        element.value.spendStatus == const OutputSpendStatus.unspent());
    return Map.fromEntries(spendable);
  }

  Future<void> scan() async {
    try {
      scanning = true;
      final wallet = await getWalletFromSecureStorage();
      final updatedWallet = await scanToTip(encodedWallet: wallet);
      print(updatedWallet);
      await saveWalletToSecureStorage(updatedWallet);
      await updateWalletStatus();
    } catch (e) {
      scanning = false;
      notifyListeners();
      rethrow;
    }
    scanning = false;
    notifyListeners();
  }
}