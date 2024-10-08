import 'package:danawallet/generated/rust/api/structs.dart';
import 'package:danawallet/states/spend_state.dart';
import 'package:danawallet/states/wallet_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OutputsScreen extends StatelessWidget {
  const OutputsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final walletState = Provider.of<WalletState>(context, listen: false);
    final spendState = Provider.of<SpendState>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('My spendable outputs'),
        ),
        body: Column(
          children: [
            Expanded(
                child: Center(
                    child: SizedBox(
              width: screenWidth * 0.90,
              child: ListView.builder(
                  itemCount: walletState.getSpendableOutputs().length,
                  itemBuilder: (context, index) {
                    String outpoint =
                        walletState.getSpendableOutputs().keys.elementAt(index);
                    ApiOwnedOutput output = walletState
                        .getSpendableOutputs()[outpoint] as ApiOwnedOutput;
                    bool isSelected =
                        spendState.selectedOutputs.containsKey(outpoint);
                    return GestureDetector(
                        onTap: () {
                          spendState.toggleOutputSelection(outpoint, output);
                        },
                        child: Card(
                          color: isSelected ? Colors.blue[100] : null,
                          child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("TxOutpoint: $outpoint"),
                                  Text("Blockheight: ${output.blockheight}"),
                                  Text("Amount: ${output.amount.field0}"),
                                  Text("Script: ${output.script}"),
                                ],
                              )),
                        ));
                  }),
            ))),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Spend selected outputs'),
                ),
              ),
            ),
          ],
        ));
  }
}
