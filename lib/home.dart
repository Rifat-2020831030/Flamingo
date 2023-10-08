import 'dart:developer';

import 'package:bottom_picker/widgets/date_picker.dart';
import 'package:data_vis/bot.dart';
import 'package:data_vis/timeLine.dart';
import 'package:flutter/material.dart';
import 'package:data_vis/firemap.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Home> {

  int index= 0;
  List<Widget> Screen = [
    Map(),
    TimeLine(),
    Image.asset('assests/images/forum.png'),
    Image.asset('assests/images/sos.png'),
    ChatBot(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Screen[index],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          currentIndex: index,
          onTap: (SelectedIndex){
            setState(() {
              index = SelectedIndex;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Home',
              ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timeline),
              label: 'Timeline',
              ),
            BottomNavigationBarItem(
              icon: Icon(Icons.forum),
              label: 'Forum',
              ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sos),
              label: 'SOS',
              ),
              BottomNavigationBarItem(
              icon: Icon(Icons.bolt),
              label: 'FiBot',
              ),
          ],
        ),
    );
  }
}