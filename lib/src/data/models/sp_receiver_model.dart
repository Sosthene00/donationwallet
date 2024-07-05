class SPReceiver {
  final int version;
  final String network;
  final List<int> scanPubkey;
  final List<int> spendPubkey;
  final String changeLabel;
  final Map<String, List<int>> labels;

  SPReceiver({
    required this.version,
    required this.network,
    required this.scanPubkey,
    required this.spendPubkey,
    required this.changeLabel,
    required this.labels,
  });

  factory SPReceiver.fromJson(Map<String, dynamic> json) {
    Map<String, List<int>> labels = {};

    for (var elem in json['labels'] as List) {
      labels[elem[0]] = List<int>.from(elem[1]);
    }

    return SPReceiver(
      version: json['version'],
      network: json['network'],
      scanPubkey: List<int>.from(json['scan_pubkey']),
      spendPubkey: List<int>.from(json['spend_pubkey']),
      changeLabel: json['change_label'],
      labels: labels,
    );
  }

  Map<String, dynamic> toJson() {
    List<dynamic> labelsList = [];

    labels.forEach((key, value) {
      labelsList.add([key, value]);
    });

    return {
      'version': version,
      'network': network,
      'scan_pubkey': scanPubkey,
      'spend_pubkey': spendPubkey,
      'change_label': changeLabel,
      'labels': labelsList,
    };
  }
}
