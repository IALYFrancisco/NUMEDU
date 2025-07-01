import 'package:flutter/material.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  runApp(NumeduApp());
}

class NumeduApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Numedu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}