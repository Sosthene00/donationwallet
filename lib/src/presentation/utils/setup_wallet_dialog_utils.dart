import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> showSeedInputDialog(
      BuildContext context, void Function(String?, String?, String?, int) update) async {
    TextEditingController seedController = TextEditingController();
    TextEditingController birthdayController = TextEditingController();
    String? errorText;

    birthdayController.addListener(() {
        try {
          int.parse(birthdayController.text);
          errorText = null; // Clear the error if parsing is successful
        } catch (e) {
          errorText = 'Birthday must be an integer';
        }
        // Trigger a rebuild to update the UI
        (context as Element).markNeedsBuild();
      });

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text("Enter Seed"),
            content: Column(
              mainAxisSize: MainAxisSize.min, // Use min size for the column
              children: [
                TextField(
                  controller: seedController,
                  decoration: InputDecoration(
                    hintText: "Seed",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.paste),
                      onPressed: () async {
                        ClipboardData? data =
                            await Clipboard.getData(Clipboard.kTextPlain);
                        if (data != null) {
                          seedController.text = data.text ?? '';
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10), // Spacing between text fields
                TextField(
                  controller: birthdayController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Wallet birthday (in blocks)",
                    errorText: errorText,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.paste),
                      onPressed: () async {
                        ClipboardData? data =
                            await Clipboard.getData(Clipboard.kTextPlain);
                        if (data != null) {
                          birthdayController.text = data.text ?? '';
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); 
                },
              ),
              TextButton(
                child: const Text("Submit"),
                onPressed: () async {
                  if (errorText == null) {
                    final mnemonic = seedController.text;
                    final birthday = int.parse(birthdayController.text);
                    update(mnemonic, null, null, birthday);
                    Navigator.of(dialogContext).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorText!),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            ],
          );}
        );
      },
    );
  }

Future<void> showKeysInputDialog(BuildContext context, Function(String?, String?, String?, int) update) async {
  TextEditingController scanKeyController = TextEditingController();
  TextEditingController spendKeyController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  String? errorText;

  birthdayController.addListener(() {
      try {
        int.parse(birthdayController.text);
        errorText = null; 
      } catch (e) {
        errorText = 'Birthday must be an integer';
      }
      // Trigger a rebuild to update the UI
      (context as Element).markNeedsBuild();
    });

  await showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text("Enter keys"),
        content: Column(
          mainAxisSize: MainAxisSize.min, 
          children: [
            TextField(
              controller: scanKeyController,
              decoration: InputDecoration(
                hintText: "Scan private key",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.paste),
                  onPressed: () async {
                    ClipboardData? data =
                        await Clipboard.getData(Clipboard.kTextPlain);
                    if (data != null) {
                      scanKeyController.text = data.text ?? '';
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 10), 
            TextField(
              controller: spendKeyController,
              decoration: InputDecoration(
                hintText: "Spend key (paste public key to make watch-only wallet)",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.paste),
                  onPressed: () async {
                    ClipboardData? data =
                        await Clipboard.getData(Clipboard.kTextPlain);
                    if (data != null) {
                      spendKeyController.text = data.text ?? '';
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 10), 
            TextField(
              controller: birthdayController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Wallet birthday (in blocks)",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.paste),
                  onPressed: () async {
                    ClipboardData? data =
                        await Clipboard.getData(Clipboard.kTextPlain);
                    if (data != null) {
                      birthdayController.text = data.text ?? '';
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(dialogContext).pop(); 
            },
          ),
          TextButton(
            child: const Text("Submit"),
            onPressed: () async {
              if (scanKeyController.text.isEmpty || spendKeyController.text.isEmpty) {
                errorText = "Must provide both keys";
              }

              if (errorText == null) {
                final scanKey = scanKeyController.text;
                final spendKey = spendKeyController.text;
                final birthday = int.parse(birthdayController.text);
                update(null, scanKey, spendKey, birthday);
                Navigator.of(dialogContext).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorText!),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      );
    },
  );
}
