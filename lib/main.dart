import 'package:flutter/material.dart';
import 'navigation.dart';

void main() {
  runApp(const SplitmoneyAppUI());
}

class SplitmoneyAppUI extends StatelessWidget {
  const SplitmoneyAppUI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splitmoney',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const BottomNavScreen(),
    );
  }
}
