import 'package:flutter/material.dart';

import 'report_list_screen.dart';
import 'create_report_screen.dart';
import 'community_chat_screen.dart';
import 'profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {

  int currentIndex = 0;

  final List<Widget> screens = const [

    ///  Feed Reports
    ReportListScreen(),

    ///  Criar Report
    CreateReportScreen(),

    ///  Comunidade
    CommunityChatScreen(),

    ///  Perfil
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: screens[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          setState(() => currentIndex = index);
        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Reports",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: "Criar",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Comunidade",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}
