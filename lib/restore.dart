import 'package:donationwallet/home.dart';
import 'package:flutter/material.dart';
import 'package:donationwallet/ffi.dart';
import 'package:donationwallet/wallet.dart';
import 'package:donationwallet/storage.dart';

class RestoreScreen extends StatefulWidget {
  @override
  _RestoreScreenState createState() => _RestoreScreenState();
}

class _RestoreScreenState extends State<RestoreScreen> {
  final TextEditingController _wordsController = TextEditingController();

  @override
  void dispose() {
    _wordsController.dispose();
    super.dispose();
  }

  void _restoreWallet() async {
    String seedWords = _wordsController.text.toString();

    // Add your restoration logic here
    SecureStorageService secureStorage = SecureStorageService();
    final walletExists = await secureStorage.isInitialized();

    if (!walletExists) {
      // First create a wallet
      final newWallet = await api.setup(
        label: await getPath(),
        network: "signet",
        seedWords: seedWords,
      );
      await secureStorage.write(key: label, value: newWallet);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restore Wallet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _wordsController,
              decoration: const InputDecoration(
                labelText: 'Enter your recovery words',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              maxLines: null, // Allows for multiple lines
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _restoreWallet;
                final navigator = Navigator.of(context);
                navigator.pushReplacement(MaterialPageRoute(
                    builder: (context) => const MyHomePage()));
              },
              child: const Text('Restore Wallet'),
            ),
          ],
        ),
      ),
    );
  }
}
