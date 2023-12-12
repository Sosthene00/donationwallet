import 'dart:async';
import 'dart:convert';

import 'package:donationwallet/ffi.dart';
import 'package:donationwallet/storage.dart';
import 'package:donationwallet/outputs.dart';
import 'package:donationwallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SpendDestination {
  final String address;
  int value;

  SpendDestination({
    required this.address,
    this.value = 0,
  });

  Map<String, dynamic> toJson() => {
        'address': address,
        'value': value,
      };
}

class SpendingRequest {
  final List<Output> inputs;
  final List<SpendDestination> outputs;

  SpendingRequest({
    required this.inputs,
    required this.outputs,
  });

  Map<String, dynamic> toJson() => {
        'inputs': inputs,
        'outputs': outputs,
      };
}

class SpendScreen extends StatefulWidget {
  final List<Output> spendingOutputs;

  const SpendScreen({super.key, required this.spendingOutputs});

  @override
  State<SpendScreen> createState() => _SpendScreenState();
}

class _SpendScreenState extends State<SpendScreen> {
  late int networkFee =
      -1; // recommended fees, -1 means there's no estimation available and user must find it by himself

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _feeRateController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _updateWallet(String tx) async {
    SecureStorageService secureStorage = SecureStorageService();

    final wallet = await secureStorage.read(key: label);
    if (wallet == null) {
      throw Exception("Can't find wallet");
    }
    final updatedWallet =
        await api.markSpentFromTransaction(blob: wallet, txHex: tx);
    try {
      await secureStorage.write(key: label, value: updatedWallet);
    } catch (e) {
      throw Exception("$e");
    }
  }

  Future<String> _updateFees(String psbt, int txSize, int feeRate) async {
    try {
      return await api.updateFees(
          psbt: psbt, subtractFrom: 0, feeRate: feeRate);
    } catch (e) {
      throw Exception("$e");
    }
  }

  Future<String> _spend(
      List<Output> spentOutputs, List<String> addresses, int feeRate) async {
    final int inAmount =
        spentOutputs.fold(0, (sum, output) => sum + output.amount);
    // We only have one destination for now
    final List<SpendDestination> outputs = addresses
        .map((a) => SpendDestination(address: a, value: inAmount))
        .toList();
    final request = SpendingRequest(
      inputs: spentOutputs,
      outputs: outputs,
    ).toJson();
    final String spendingRequest = jsonEncode(request);
    String result;
    try {
      result = await api.spendTo(spendingRequest: spendingRequest);
      // return result;
    } catch (e) {
      throw Exception("Failed to spend: ${e.toString()}");
    }
    SecureStorageService secureStorage = SecureStorageService();

    final wallet = await secureStorage.read(key: label);
    if (wallet == null) {
      throw Exception("Can't find wallet");
    }
    final signed = await api.signPsbtAt(blob: wallet, psbt: result, inputIndex: 0);
    final finalized = await api.finalizePsbt(psbt: signed);
    return finalized;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Transaction'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Destination Address'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _addressController,
                    readOnly: true, // Makes the field read-only
                    decoration: const InputDecoration(
                      hintText: 'Paste destination address here',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.paste),
                  onPressed: () async {
                    ClipboardData? data =
                        await Clipboard.getData(Clipboard.kTextPlain);
                    _addressController.text = data?.text ?? '';
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Fee Rate (satoshis/vB)'),
            TextField(
              controller: _feeRateController,
              keyboardType: TextInputType.numberWithOptions(decimal: false),
              decoration: const InputDecoration(
                hintText: 'Enter fee rate',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final String address = _addressController.text;
                final int? fees = int.tryParse(_feeRateController.text);
                if (fees == null) {
                  throw Exception("Invalid fees");
                }
                List<String> addresses = List.filled(1, address);
                final tx =
                    await _spend(widget.spendingOutputs, addresses, fees);
                print("$tx");
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Spend'),
            ),
          ],
        ),
      ),
    );
  }
}
