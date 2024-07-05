import 'package:bitcoin_ui/bitcoin_ui.dart';
import 'package:donationwallet/src/presentation/notifiers/chain_notifier.dart';
import 'package:donationwallet/src/presentation/notifiers/wallet_notifier.dart';
import 'package:donationwallet/src/utils/scan_stream.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:donationwallet/src/presentation/utils/wallet_utils.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreen();
}

class _WalletScreen extends State<WalletScreen> {
  late ScanProgressService _scanProgressService;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();

    _scanProgressService = ScanProgressService();
    _scanProgressService.scanProgressStream.listen(((event) {
      final walletNotifier = context.watch<WalletNotifier>();
      int start = event.start;
      int current = event.current;
      int end = event.end;
      double scanned = (current - start).toDouble();
      double total = (end - start).toDouble();
      double progress = scanned / total;
      walletNotifier.setProgress(progress);
      walletNotifier.setBalance(event.balance);
    }));
  }

  @override
  void dispose() {
    super.dispose();
    _scanProgressService.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletNotifier = context.watch<WalletNotifier>();
    final chainNotifier = context.watch<ChainNotifier>();

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10.0),
                // Spacer(),
                Text(
                  'Balance: ${walletNotifier.wallet?.balance}',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const Spacer(),
                // progressWidget,
                showProgressWidget(context),
                const Spacer(),
                // showWalletStateText(context, walletNotifier, chainNotifier),
                buildBottomButtons(context, walletNotifier),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget showWalletStateText(context, WalletNotifier walletNotifier, ChainNotifier chainNotifier) {
  //   final wallet = walletNotifier.wallet;
  //   if (wallet == null) {
  //     showErrorDialog(context, "Missing wallet");
  //   }

  //   final tip = chainNotifier.
  //   final toScan = chain - walletNotifier.lastScan;

  //   String text;

  //   if (walletNotifier.isScanning) {
  //     text = 'Scanning: $toScan blocks';
  //   } else if (toScan == 0) {
  //     text = 'Up to date!';
  //   } else {
  //     text = 'New blocks: $toScan';
  //   }

  //   return Text(
  //     text,
  //     style: Theme.of(context).textTheme.displaySmall,
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   final walletNotifier = Provider.of<WalletNotifier>(context);

  //   Widget progressWidget = walletNotifier.isScanning
  //       ? SizedBox(
  //           width: 100,
  //           height: 100,
  //           child: CircularProgressIndicator(
  //             backgroundColor: Colors.grey[200],
  //             value: walletNotifier.wallet.lastScan,
  //             strokeWidth: 6.0,
  //           ),
  //         )
  //       : ElevatedButton(
  //           style: ElevatedButton.styleFrom(
  //             textStyle: Theme.of(context).textTheme.headlineLarge,
  //             shape: const CircleBorder(),
  //             padding: const EdgeInsets.all(60.0),
  //           ),
  //           onPressed: () async {
  //             try {
  //               await walletNotifier.scan();
  //             } catch (e) {
  //               displayNotification(e.toString());
  //             }
  //           },
  //           child: const Text('Scan'));

  //   if (!walletNotifier.walletLoaded) {
  //     return const Center(
  //       child: CircularProgressIndicator(),
  //     );
  //   }

  //   return Column(
  //     children: [
  //       Expanded(
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               const SizedBox(height: 10.0),
  //               // Spacer(),
  //               Text(
  //                 'Balance: ${walletNotifier.amount}',
  //                 style: Theme.of(context).textTheme.displayMedium,
  //               ),
  //               const Spacer(),
  //               progressWidget,
  //               const Spacer(),
  //               showWalletStateText(context),
  //               const Spacer(),
  //               buildBottomButtons(context),
  //               const Spacer(),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget buildBottomButtons(
      BuildContext context, WalletNotifier walletNotifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: BitcoinButtonFilled(
              title: 'Receive',
              onPressed: () {
                showReceiveDialog(context, walletNotifier.wallet!.address);
              },
            ),
          ),
          const SizedBox(width: 10), // Spacing between the buttons
          Expanded(
            child: BitcoinButtonFilled(
              title: 'Send',
              onPressed: () async {
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => const SpendScreen()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
