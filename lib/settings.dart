import 'package:donationwallet/ffi.dart';
import 'package:donationwallet/introduction.dart';
import 'package:donationwallet/storage.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () async {
            api.restartNakamoto();
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('Restart nakamoto'),
        ),
        ElevatedButton(
          onPressed: () async {
            // await api.resetWallet();
            await api.restartNakamoto();
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('Reset wallet to birthday'),
        ),
        ElevatedButton(
          onPressed: () async {
            await SecureStorageService().resetWallet();
            // await api.restartNakamoto();
            final navigator = Navigator.of(context);
            navigator.pushReplacement(MaterialPageRoute(
                builder: (context) => const IntroductionPage()));
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('Wipe wallet'),
        ),
      ],
    );
  }
}
