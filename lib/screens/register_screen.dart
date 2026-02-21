import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  bool loading = false;

  Future<void> register() async {

    setState(() => loading = true);

    try {

      await AuthService().register(
        emailController.text.trim(),
        passwordController.text.trim(),
        usernameController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context);

    } catch (_) {}

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Registrar")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: usernameController,
              decoration:
              const InputDecoration(labelText: "Username"),
            ),

            TextField(
              controller: emailController,
              decoration:
              const InputDecoration(labelText: "Email"),
            ),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration:
              const InputDecoration(labelText: "Senha"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed:
              loading ? null : register,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Criar conta"),
            ),
          ],
        ),
      ),
    );
  }
}