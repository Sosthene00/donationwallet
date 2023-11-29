// ignore_for_file: avoid_print

import 'package:donationwallet/home.dart';
import 'package:donationwallet/introduction.dart';
import 'package:donationwallet/storage.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool initialized = await SecureStorageService().isInitialized();

  Widget firstPage =
      initialized ? const MyHomePage() : const IntroductionPage();

  runApp(MyApp(firstPage: firstPage));
}

class MyApp extends StatelessWidget {
  final Widget firstPage;

  const MyApp({super.key, required this.firstPage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Silent payments',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: firstPage,
    );
  }
}
