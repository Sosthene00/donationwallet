import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:donationwallet/ffi.dart';
import 'package:donationwallet/storage.dart';
import 'package:donationwallet/wallet.dart';

class Output {
  final String txoutpoint;
  final String tweakData;
  final int index;
  final List<int> tweak;
  final int blockheight;
  final int amount;
  final String script;
  final String status;

  Output({
    required this.txoutpoint,
    required this.tweakData,
    required this.index,
    required this.tweak,
    required this.blockheight,
    required this.amount,
    required this.script,
    required this.status,
  });

  factory Output.fromJson(Map<String, dynamic> json) {
    return Output(
      txoutpoint: json['txoutpoint'],
      tweakData: json['tweak_data'],
      index: json['index'],
      tweak: List<int>.from(json['tweak']),
      blockheight: json['blockheight'],
      amount: json['amount'],
      script: json['script'],
      status: json['status'],
    );
  }
}

class OutputsScreen extends StatefulWidget {
  const OutputsScreen({super.key});

  @override
  State<OutputsScreen> createState() => _OutputsScreenState();
}

class _OutputsScreenState extends State<OutputsScreen> {
  List<Output> outputs = [];

  @override
  void initState() {
    super.initState();
    _loadOutputs();
  }

  Future<void> _loadOutputs() async {
    try {
      final result = await _getOutputs();
      List<Output> parsedOutputs = result
          .map((jsonString) => Output.fromJson(json.decode(jsonString)))
          .toList();
      setState(() {
        outputs = parsedOutputs;
      });
    } catch (e) {
      print('Error fetching outputs: $e');
    }
  }

  Future<List<String>> _getOutputs() async {
    SecureStorageService secureStorage = SecureStorageService();

    final wallet = await secureStorage.read(key: label);
    if (wallet == null) {
      throw Exception("Can't find wallet");
    } else {
      return await api.getSpendableOutputs(blob: wallet);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My spendable outputs'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _loadOutputs(); // Refresh the data when the button is pressed
            },
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: screenWidth * 0.90,
          child: outputs.isEmpty
              ? const CircularProgressIndicator() // Show loading indicator when data is being fetched
              : ListView.builder(
                  itemCount: outputs.length,
                  itemBuilder: (context, index) {
                    Output output = outputs[index];
                    return Card(
                        child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("TxOutpoint: ${output.txoutpoint}"),
                          Text("Blockheight: ${output.blockheight}"),
                          Text("Amount: ${output.amount}"),
                          Text("Script: ${output.script}"),
                        ],
                      ),
                    ));
                  },
                ),
        ),
      ),
    );
  }
}
