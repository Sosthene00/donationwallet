import 'package:donationwallet/home.dart';
import 'package:donationwallet/restore.dart';
import 'package:flutter/material.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: SizedBox(
                width: double.infinity,
                height: 120.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.headlineLarge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    navigator.pushReplacement(MaterialPageRoute(
                        builder: (context) => const MyHomePage()));
                  },
                  child: const Text('Create new wallet'),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: SizedBox(
                width: double.infinity,
                height: 120.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.headlineLarge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RestoreScreen()));
                  },
                  child: const Text('Restore existing wallet'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
