import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterScreen> {

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  Future register() async {
    await AuthService().register(
      email.text,
      password.text,
      name.text,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: "Nome"),
            ),

            TextField(
              controller: email,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Senha"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: register,
              child: const Text("Cadastrar"),
            )
          ],
        ),
      ),
    );
  }
}