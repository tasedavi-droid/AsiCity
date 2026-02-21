import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  final controller = TextEditingController();

  String? currentUsername;

  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  Future<void> loadUsername() async {

    final user = AuthService().currentUser;
    if (user == null) return;

    final username =
        await AuthService().getUsername(user.uid);

    setState(() => currentUsername = username);
  }

  Future<void> updateUsername() async {

    if (controller.text.trim().isEmpty) return;

    await AuthService()
        .updateUsername(controller.text.trim());

    await loadUsername();
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Perfil")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            Text(
              "Username atual:",
              style: TextStyle(color: Colors.grey[400]),
            ),

            Text(
              currentUsername ?? "...",
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Novo username",
              ),
            ),

            ElevatedButton(
              onPressed: updateUsername,
              child: const Text("Atualizar"),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: () async {
                await AuthService().logout();
              },
              child: const Text("Sair"),
            ),
          ],
        ),
      ),
    );
  }
}