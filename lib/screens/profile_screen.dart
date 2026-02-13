import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final auth = AuthService();
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Perfil")),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(Icons.person, size: 80),

            const SizedBox(height: 20),

            Text(user?.email ?? "Usuário"),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await auth.logout();
              },
              child: const Text("Sair"),
            ),
          ],
        ),
      ),
    );
  }
}