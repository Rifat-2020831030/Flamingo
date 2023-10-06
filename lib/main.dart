import 'package:data_vis/home.dart';
import 'package:data_vis/firemap.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const home());
}

class home extends StatelessWidget {
  const home({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Home()
        ),
    );
  }
}

