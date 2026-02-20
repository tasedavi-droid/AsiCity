import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'main_navigation.dart';

class CreateUsernameScreen extends StatefulWidget {
  const CreateUsernameScreen({super.key});

  @override
  State<CreateUsernameScreen> createState() =>
      _CreateUsernameScreenState();
}

class _CreateUsernameScreenState
    extends State<CreateUsernameScreen> {

  final controller = TextEditingController();
  bool loading = false;

  Future<void> saveUserName() async {

    if (controller.text.trim().isEmpty) return;

    setState(() => loading = true);

    await AuthService()
        .updateUsername(controller.text.trim());

    setState(() => loading = false);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainNavigation(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Criar nome")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Nome público",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed:
                  loading ? null : saveUserName,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}
