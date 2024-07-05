import 'package:donationwallet/src/data/models/sp_receiver_model.dart';

class SpClient {
  final String label;
  final String scanSk;
  final Map<String, dynamic> spendKey;
  final String? mnemonic;
  final SPReceiver spReceiver;

  SpClient({
    required this.label,
    required this.scanSk,
    required this.spendKey,
    required this.mnemonic,
    required this.spReceiver,
  });

  factory SpClient.fromJson(Map<String, dynamic> json) {
    return SpClient(
      label: json['label'],
      scanSk: json['scan_sk'],
      spendKey: json['spend_key'],
      mnemonic: json['mnemonic'],
      spReceiver: SPReceiver.fromJson(json['sp_receiver']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'scan_sk': scanSk,
      'spend_key': spendKey,
      'mnemonic': mnemonic,
      'sp_receiver': spReceiver.toJson(),
    };
  }
}
