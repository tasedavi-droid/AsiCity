import 'package:flutter/material.dart';
import 'report_list_screen.dart';
import 'chat_screen.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {

  int index = 0;

  final screens = [
    ReportListScreen(),
    ChatScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AsiCity"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().logout();
              Navigator.pushReplacementNamed(context, "/login");
            },
          )
        ],
      ),

      body: screens[index],

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "/create"),
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.report), label: "Reports"),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat), label: "Chat"),
        ],
      ),
    );
  }
}
