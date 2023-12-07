import 'dart:async';

import 'package:donationwallet/ffi.dart';
import 'package:donationwallet/storage.dart';
import 'package:donationwallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InformationScreen extends StatelessWidget {
  final Function updateBirthdayCallback;

  InformationScreen({
    this.address = "",
    this.birthday = 0,
    this.scanHeight = 0,
    this.tip = 0,
    required this.updateBirthdayCallback,
    super.key,
  });

  String address;
  int birthday;
  int scanHeight;
  int tip;

  final _controller = TextEditingController();

  Future<void> _setWalletBirthday(int birthday) async {
    SecureStorageService secureStorage = SecureStorageService();
    final encryptedWallet = await secureStorage.read(key: label);
    if (encryptedWallet == null) {
      throw Exception("Wallet is not set up");
    }
    final updated = await api.setWalletBirthday(
        blob: encryptedWallet, newBirthday: birthday);
    await secureStorage.write(key: label, value: updated);
    updateBirthdayCallback(birthday);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            'Silent payments address:',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            address,
            textAlign: TextAlign.center,
            softWrap: true,
          ),
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: address));
            },
          ),
          const Spacer(),
          Text(
            'Wallet birthday:',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text('$birthday'),
          const Spacer(),
          Text(
            'Scan height:',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text('$scanHeight'),
          const Spacer(),
          Text(
            'Tip height:',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text('$tip'),
          ElevatedButton(
            onPressed: () async {
              showDialog<int>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Enter Birthday'),
                      content: TextField(
                        controller: _controller,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            hintText: 'Enter your birthday (numeric value)'),
                        onSubmitted: (value) {
                          Navigator.of(context).pop(int.tryParse(value));
                        },
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Close the dialog without saving
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Extract value from the TextField and close the dialog
                            // Replace 'textFieldController' with your text field controller
                            Navigator.of(context)
                                .pop(int.tryParse(_controller.text));
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  }).then((value) {
                // 'value' holds the numeric value entered by the user, or null if input is invalid or cancelled
                if (value != null) {
                  _setWalletBirthday(value);
                  Navigator.of(context).pop();
                }
              });
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Set wallet birthday'),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
