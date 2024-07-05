import 'package:bitcoin_ui/bitcoin_ui.dart';
import 'package:donationwallet/src/presentation/screens/settings_screen.dart';
import 'package:donationwallet/src/presentation/screens/setupwallet_screen.dart';
import 'package:donationwallet/src/utils/constants.dart';
import 'package:donationwallet/src/utils/log.dart';
import 'package:flutter/scheduler.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:donationwallet/src/presentation/screens/wallet_screen.dart';
import 'package:donationwallet/src/presentation/notifiers/wallet_notifier.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    const WalletScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();

    final logStreamService = LogStreamService();

    logStreamService.logStream.listen((logEntry) {
      Logger().i('Log Entry: ${logEntry.msg}');
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WalletNotifier>(builder: (context, walletNotifier, child) {
        if (walletNotifier.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (walletNotifier.wallet == null) {
          return const SetupWalletScreen();
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Silent Payments'),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            body: IndexedStack(
              index: _selectedIndex,
              children: _widgetOptions,
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Image(
                      image: const AssetImage("icons/wallet.png",
                          package: "bitcoin_ui"),
                      color: Bitcoin.neutral3Dark),
                  label: 'Wallet',
                ),
                BottomNavigationBarItem(
                  icon: Image(
                      image: const AssetImage("icons/gear.png",
                          package: "bitcoin_ui"),
                      color: Bitcoin.neutral3Dark),
                  label: 'Settings',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.green,
              onTap: _onItemTapped,
            ),
          );
        }
      }),
    );
  }
}
