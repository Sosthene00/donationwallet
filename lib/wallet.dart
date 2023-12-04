import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:donationwallet/ffi.dart';
import 'package:donationwallet/storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

const String label = "default";

Future<String> getPath() async {
  final Directory appDocumentsDir = await getApplicationSupportDirectory();
  final String path = appDocumentsDir.path;

  return '$path/$label';
}

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int balance = 0;
  int tipheight = 0;
  int scanheight = 0;
  int peercount = 0;
  Timer? _timer;

  String spaddress = '';

  bool scanning = false;
  double progress = 0.0;
  String lastScan = "";

  @override
  void initState() {
    super.initState();
    _setup();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      _timer = Timer.periodic(const Duration(seconds: 5), (Timer t) async {
        if (!scanning) {
          SecureStorageService secureStorage = SecureStorageService();
          final encryptedWallet = await secureStorage.read(key: label);
          if (encryptedWallet == null) {
            throw Exception("Wallet is not set up");
          }
          try {
            final peercount = await api.getPeerCount();
            setState(() {
              this.peercount = peercount;
            });
          } catch (e) {
            throw Exception("getPeerCount returned error: ${e.toString()}");
          }
          if (peercount > 0) {
            try {
              await updateWalletInfo();
            } catch (e) {
              print("getWalletInfo returned error: ${e.toString()}");
            }
            final amt = await api.getWalletBalance(blob: encryptedWallet);

            setState(() {
              balance = amt;
            });
          }
        }
      });
    });
  }

  Future<void> updateWalletInfo() async {
    SecureStorageService secureStorage = SecureStorageService();
    final encryptedWallet = await secureStorage.read(key: label);
    if (encryptedWallet == null) {
      throw Exception("Wallet is not set up");
    }
    try {
      final info = await api.getWalletInfo(blob: encryptedWallet);
      setState(() {
        scanheight = info.scanHeight;
        tipheight = info.blockTip;
      });
    } catch (e) {
      throw Exception("getWalletInfo failed with error: ${e.toString()}");
    }
  }

  Future<void> _setup() async {
    api.createLogStream().listen((event) {
      print('RUST: ${event.msg}');
    });

    api.createScanProgressStream().listen(((event) {
      int start = event.start;
      int current = event.current;
      int end = event.end;
      double scanned = (current - start).toDouble();
      double total = (end - start).toDouble();
      double progress = scanned / total;
      if (current == end) {
        progress = 0.0;
      }
      setState(() {
        this.progress = progress;
        scanheight = current;
      });
    }));

    api.createAmountStream().listen((event) {
      setState(() {
        balance = event;
      });
    });

    SecureStorageService secureStorage = SecureStorageService();
    final walletExists = await secureStorage.isInitialized();

    if (!walletExists) {
      // First create a wallet
      final newWallet = await api.setup(
        label: await getPath(),
        network: "signet",
      );
      await secureStorage.write(key: label, value: newWallet);
    }

    final wallet = await secureStorage.read(key: label);
    if (wallet == null) {
      Exception("Can't find wallet");
    } else {
      final amt = await api.getWalletBalance(blob: wallet);
      setState(() {
        balance = amt;
      });
    }
    // this starts nakamoto, will block forever (or until client is restarted)
    api.startNakamoto();
  }

  Future<void> _updateLastScan() async {
    if (!scanning) {
      SecureStorageService secureStorage = SecureStorageService();
      final encryptedWallet = await secureStorage.read(key: label);
      if (encryptedWallet == null) {
        throw Exception("Wallet is not set up");
      }

      final parsedWallet = jsonDecode(encryptedWallet);
      print("$parsedWallet");
      lastScan = parsedWallet['timestamp'];
    } else {
      throw Exception("Currently scanning for new outputs");
    }
  }

  Future<void> _scanToTip() async {
    if (!scanning) {
      SecureStorageService secureStorage = SecureStorageService();
      final encryptedWallet = await secureStorage.read(key: label);
      if (encryptedWallet == null) {
        throw Exception("Wallet is not set up");
      }
      scanning = true;
      try {
        final updatedWallet = await api.scanToTip(blob: encryptedWallet);
        await secureStorage.write(key: label, value: updatedWallet);
        // now update lastScan
        await _updateLastScan();
      } catch (e) {
        print(e.toString());
      }
      scanning = false;
    }
  }

  Widget showScanText() {
    final toScan = tipheight - scanheight;

    String text;
    if (scanheight == 0 || peercount == 0) {
      text = 'Waiting for peers';
    } else if (toScan == 0) {
      text = 'Up to date!';
    } else {
      text = 'New blocks: $toScan';
    }

    return Text(
      text,
      style: Theme.of(context).textTheme.displaySmall,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text('Nakamoto peer count: $peercount'),
          const SizedBox(
            height: 80,
          ),
          Text(
            'Balance: $balance',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const Spacer(),
          SizedBox(
            width: 100,
            height: 100,
            child: Visibility(
              visible: progress != 0.0,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 6.0,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          showScanText(),
          const Spacer(),
          ElevatedButton(
            onPressed: peercount == 0 || tipheight < scanheight
                ? null
                : () async {
                    await _scanToTip();
                  },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Scan for payments'),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
