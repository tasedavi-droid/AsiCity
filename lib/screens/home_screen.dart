import 'package:flutter/material.dart';

import 'report_list_screen.dart';
import 'community_chat_screen.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {

  int index = 0;

  final screens = [
    const ReportListScreen(),
    const MapScreen(lat: 0.0, lng: 0.0),
    const CommunityChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: screens[index],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: "Feed"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Mapa"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Comunidade"),
        ],
      ),
    );
  }
}