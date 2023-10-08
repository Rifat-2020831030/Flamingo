import 'package:flutter/material.dart';

class Distance3d extends StatefulWidget {
  const Distance3d({super.key, required this.image3d});

  final Image image3d;

  @override
  State<Distance3d> createState() => _Distance3dState();
}

class _Distance3dState extends State<Distance3d> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 50.0,
          ),
          Image.asset('assets/images/firearea.gif'),
          widget.image3d,
        ],
      )//Image.asset('assets/distance/distance3d1.gif'),
    );
  }
}
