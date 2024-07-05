import 'package:donationwallet/src/presentation/notifiers/chain_notifier.dart';
import 'package:donationwallet/src/presentation/screens/home_screen.dart';
import 'package:donationwallet/src/presentation/utils/error_dialog_utils.dart';
import 'package:donationwallet/src/presentation/notifiers/wallet_notifier.dart';
import 'package:donationwallet/src/presentation/utils/setup_wallet_dialog_utils.dart';
import 'package:donationwallet/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class SetupWalletScreen extends StatefulWidget {
  const SetupWalletScreen({super.key});

  @override
  State<SetupWalletScreen> createState() => _SetupWalletScreen();
}

class _SetupWalletScreen extends State<SetupWalletScreen> {
  String? _mnemonic;
  String? _scanKey;
  String? _spendKey;
  int _birthday = 0;

  void updateSetup(String? mnemonic, String? scanKey, String? spendKey, int birthday) {
    setState(() {
      _mnemonic = mnemonic;
      _scanKey = scanKey;
      _spendKey = spendKey;
      _birthday = birthday;
    });
  }

  @override
  Widget build(BuildContext context) {
    final chainNotifier = context.watch<ChainNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet creation/restoration'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Flex(
          mainAxisAlignment: MainAxisAlignment.center,
          direction: Axis.vertical,
          children: [
            Consumer<WalletNotifier>(builder: (context, walletNotifier, child) {
              return Flexible(child: 
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.headlineLarge,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: const Size(double.infinity, 60),
                      ),
                      onPressed: () async {
                        final tip = chainNotifier.tip;
                        await walletNotifier.createWallet(defaultLabel, null, null, null, tip, defaultNetwork);
                        if (walletNotifier.error != null) {
                          if (context.mounted) {
                            showErrorDialog(context, walletNotifier.error!);
                          }
                        } else if (walletNotifier.wallet != null) {
                          if (context.mounted) {
                            showErrorDialog(context, "Wallet created");
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            showErrorDialog(context, "Wallet is empty");
                          }
                        }
                      },
                      child: const Text('Create New Wallet'),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.headlineLarge,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: const Size(double.infinity, 60),
                      ),
                      onPressed: () async {
                        await showSeedInputDialog(context, updateSetup);
                        if (_mnemonic == null) {
                          return;
                        }
                        await walletNotifier.createWallet(defaultLabel, _mnemonic, null, null, _birthday, defaultNetwork);
                        if (walletNotifier.error != null) {
                          if (context.mounted) {
                            showErrorDialog(context, walletNotifier.error!);
                          }
                        } else if (walletNotifier.wallet != null) {
                          if (context.mounted) {
                            showErrorDialog(context, "Wallet created");
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            showErrorDialog(context, "Wallet is empty");
                          }
                        }
                      },
                      child: const Text('Restore from seed'),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.headlineLarge,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: const Size(double.infinity, 60),
                      ),
                      onPressed: () async {
                        await showSeedInputDialog(context, updateSetup);
                        if (_scanKey == null || _spendKey == null) {
                          return;
                        }
                        await walletNotifier.createWallet(defaultLabel, _mnemonic, null, null, _birthday, defaultNetwork);
                        if (walletNotifier.error != null) {
                          if (context.mounted) {
                            showErrorDialog(context, walletNotifier.error!);
                          }
                        } else if (walletNotifier.wallet != null) {
                          if (context.mounted) {
                            showErrorDialog(context, "Wallet created");
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            showErrorDialog(context, "Wallet is empty");
                          }
                        }
                      },
                      child: const Text('Restore with keys'),
                    ),
                    const Spacer(),
                  ]
                )
              );
            }),
          ],
        ),
      ),
    );
  }
}