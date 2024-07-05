import 'package:donationwallet/src/presentation/notifiers/wallet_notifier.dart';
import 'package:donationwallet/src/presentation/utils/error_dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

Widget showProgressWidget(BuildContext context) {
  final walletNotifier = context.watch<WalletNotifier>();

  return walletNotifier.isScanning
    ? SizedBox(
        width: 100,
        height: 100,
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey[200],
          value: walletNotifier.progress,
          strokeWidth: 6.0,
        ),
      )
    : ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle: Theme.of(context).textTheme.headlineLarge,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(60.0),
        ),
        onPressed: () async {
          await walletNotifier.updateWallet();

          if (walletNotifier.error != null) {
            if (context.mounted) {
              Logger().e(walletNotifier.error!);
              showErrorDialog(context, walletNotifier.error!);
            }
          }
        },
        child: const Text('Scan'));
}

void showReceiveDialog(BuildContext context, String address) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Your address'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SingleChildScrollView(
              child: BarcodeWidget(data: address, barcode: Barcode.qrCode()),
            ),
            const SizedBox(height: 20),
            SelectableText(address),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
