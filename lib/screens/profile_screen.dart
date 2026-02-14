import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {

  final controller = TextEditingController();
  bool loading = false;

  Future<void> saveUserName() async {

    final user = AuthService().currentUser;
    if (user == null) return;

    if (controller.text.trim().isEmpty) return;

    setState(() => loading = true);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .set({
          "userName": controller.text.trim(),
        }, SetOptions(merge: true));

    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Nome salvo!")),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Perfil")),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Seu nome público",
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : saveUserName,
                child: const Text("Salvar nome"),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => AuthService().logout(),
                child: const Text("Sair"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
