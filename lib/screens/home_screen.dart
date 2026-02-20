import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AsiCity"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 20),

            const Text(
              "Bem-vindo ao AsiCity",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            _homeButton(
              context,
              title: "Ver Reports",
              icon: Icons.report,
              route: "/reports",
            ),

            _homeButton(
              context,
              title: "Chat da Comunidade",
              icon: Icons.chat,
              route: "/community_chat",
            ),

            _homeButton(
              context,
              title: "Perfil",
              icon: Icons.person,
              route: "/profile",
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton.icon(
          icon: Icon(icon),
          label: Text(title),
          onPressed: () {
            Navigator.pushNamed(context, route);
          },
        ),
      ),
    );
  }
}
