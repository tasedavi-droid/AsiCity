import 'package:flutter/material.dart';
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

    final username =
        await AuthService().getUsername(user.uid);

    setState(() => loading = true);

    final report = ReportModel(
      id: "",
      category: selectedCategory,
      description: controller.text.trim(),
      lat: 0,
      lng: 0,
      userId: user.uid,
      userName: username,
      createdAt: null,
    );

    await ReportService().createReport(report);

    setState(() => loading = false);

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Criar Report")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            DropdownButtonFormField(
              value: selectedCategory,
              items: categories
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c),
                      ))
                  .toList(),
              onChanged: (v) =>
                  setState(() =>
                      selectedCategory = v!),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "Descreva o problema",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed:
                  loading ? null : createReport,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Publicar"),
            ),
          ],
        ),
      ),
    );
  }
}
