import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/report_model.dart';
import '../services/report_service.dart';
import '../services/auth_service.dart';

class CreateReportScreen extends StatefulWidget {
  const CreateReportScreen({super.key});

  @override
  State<CreateReportScreen> createState() =>
      _CreateReportScreenState();
}

class _CreateReportScreenState
    extends State<CreateReportScreen> {

  final controller = TextEditingController();

  String selectedCategory = "Infraestrutura";
  bool loading = false;

  final categories = [
    "Infraestrutura",
    "Iluminação",
    "Segurança",
    "Trânsito",
    "Limpeza",
    "Outros",
  ];

  Future<void> createReport() async {

    final user = AuthService().currentUser;
    if (user == null) return;

    if (controller.text.trim().isEmpty) return;

    setState(() => loading = true);

    try {

      final username =
          await AuthService().getUsername(user.uid) ?? "Usuário";

      final report = ReportModel(
        id: "",
        category: selectedCategory,
        description: controller.text.trim(),
        userId: user.uid,
        userName: username,
        createdAt: Timestamp.now(),
      );

      await ReportService().createReport(report);

      if (!mounted) return;


      Navigator.pushNamedAndRemoveUntil(
        context,
        '/main_nav',
        (_) => false,
      );

    } catch (e) {
      debugPrint(e.toString());
    }

  
  
    setState(() => loading = false);
  
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Criar Report")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categories
                  .map((c) => DropdownMenuItem(
                value: c,
                child: Text(c),
              ))
                  .toList(),
              onChanged: (v) =>
                  setState(() => selectedCategory = v!),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "Descreva o problema",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : createReport,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Publicar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}