import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:donationwallet/ffi.dart';
import 'package:donationwallet/information.dart';
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
  int birthday = 0;
  int peercount = 0;
  Timer? _timer;

  String spaddress = '';

  bool scanning = false;
  double progress = 0.0;

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
              final newTip = await api.getTip();
              final amt = await api.getWalletBalance(blob: encryptedWallet);
              setState(() {
                tipheight = newTip;
                balance = amt;
              });
            } catch (e) {
              print("getTip returned error: ${e.toString()}");
            }
          }
        }
      });
    });
  }

  Future<void> _setup() async {
    api.createLogStream().listen((event) {
      print('RUST: ${event.msg}');
    });

    print("Starting _setup");

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
      throw Exception("Can't find wallet");
    } else {
      final amt = await api.getWalletBalance(blob: wallet);
      final address = await api.getReceivingAddress(blob: wallet);
      setState(() {
        balance = amt;
        spaddress = address;
      });
    }

    try {
      await api.startNakamoto();
    } catch (e) {
      throw Exception("Failed to start nakamoto with error: ${e.toString()}");
    }

    print("Finished _setup");
  }

  Future<void> _shutdown() async {
    while (scanning) {
      print("Waiting for scan to finish");
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
        final updatedWallet =
            await api.scanFrom(blob: encryptedWallet, height: birthday);

        final newBalance = await api.getWalletBalance(blob: updatedWallet);
        final parsedWallet = json.decode(updatedWallet);
        final scanStatus = parsedWallet['scan_status'];
        setState(() {
          balance = newBalance;
          scanheight = scanStatus['scan_height'];
          tipheight = scanStatus['block_tip'];
          birthday = scanStatus['birthday'];
        });

        await secureStorage.write(key: label, value: updatedWallet);
      } catch (e) {
        print(e.toString());
      }
      scanning = false;
    } else {
      print("Scanning already in progress");
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

  void updateWalletBirthday(int birthday) {
    setState(() {
      this.birthday = birthday;
    });
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
            height: 40,
          ),
          Text(
            'Balance: $balance',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const Spacer(),
          SizedBox(
            width: 80,
            height: 80,
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
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => InformationScreen(
                        address: spaddress,
                        birthday: birthday,
                        scanHeight: scanheight,
                        tip: tipheight,
                        updateBirthdayCallback: updateWalletBirthday,
                      )));
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('See more information'),
          ),
        ],
      ),
    );
  }
}
