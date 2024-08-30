import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:plant_vision/Feature/about.dart';
import 'package:plant_vision/Feature/crop_recommend.dart';
import 'package:plant_vision/Feature/detect_disease.dart';
import 'package:plant_vision/Feature/plant_chat.dart';
import 'package:plant_vision/style.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    About(),
    DetectDisease(),
    PlantChat(),
    CropRecommend()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),

      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 252, 239, 249),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
            backgroundColor: kBgColor,
            color: kColorYellowGreen,
            activeColor: kColorPakistanGreen,
            tabBackgroundColor: kColorPakistanGreen.withOpacity(0.2),
            gap: 8,
            padding: EdgeInsets.all(16.0),
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            tabs: const [
              GButton(
                icon: Icons.home,
                iconSize: 28.0,
                text: 'Home',
              ),
              GButton(
                icon: Icons.camera_alt_outlined,
                iconSize: 28.0,
                text: 'Detect',
              ),
              GButton(
                icon: Icons.chat_bubble,
                iconSize: 28.0,
                text: 'Chat',
              ),
              GButton(
                icon: Icons.recommend_outlined,
                iconSize: 28.0,
                text: 'Recommend',
              ),
            ],
            onTabChange: _onItemTapped,
          ),
        ),
      ),
    );
  }
}