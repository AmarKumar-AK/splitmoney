import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(SplitwiseAppUI());
}

class SplitwiseAppUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splitmoney',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: HomeScreen(),
    );
  }
}
