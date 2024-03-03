import 'package:flutter/material.dart';
import 'package:thaiqr/thaiqr.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Thai QR"),
        ),
        body: ThaiQRWidget(
          mobileOrId: "1234567890123",
          amount: "100.23",
          showHeader: false,
        ),
      ),
    );
  }
}
