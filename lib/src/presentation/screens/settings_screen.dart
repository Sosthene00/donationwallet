import 'package:bitcoin_ui/bitcoin_ui.dart';
import 'package:donationwallet/src/presentation/notifiers/wallet_notifier.dart';
import 'package:donationwallet/src/presentation/screens/home_screen.dart';
import 'package:donationwallet/src/presentation/screens/setupwallet_screen.dart';
import 'package:donationwallet/src/presentation/utils/error_dialog_utils.dart';
import 'package:donationwallet/src/utils/constants.dart';
import 'package:donationwallet/src/utils/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final walletNotifier = context.watch<WalletNotifier>();

    return Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: 
        [
          BitcoinButtonOutlined(
            title: 'Wipe wallet',
            onPressed: () async {
              await walletNotifier.rmWallet();
              if (walletNotifier.error != null) {
                if (context.mounted) {
                  showErrorDialog(context, walletNotifier.error!);
                }
              }
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              }
            },
          ),
        ], 
    );
  }
}
