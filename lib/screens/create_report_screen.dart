import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../services/auth_service.dart';

class CreateReportScreen extends StatefulWidget {
  const CreateReportScreen({super.key});

  @override
  State<CreateReportScreen> createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReportScreen> {

  final controller = TextEditingController();
  String selectedCategory = "Outros";

  String? imageBase64;

  bool loading = false;

  final picker = ImagePicker();

  /// PICK IMAGE WEB + MOBILE
  Future pickImage() async {

    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final bytes = await image.readAsBytes();

    setState(() {
      imageBase64 = base64Encode(bytes);
    });
  }

  Future createReport() async {

    final user = AuthService().currentUser;
    if (user == null) return;

    if (controller.text.trim().isEmpty) return;

    setState(() => loading = true);

    /// BUSCAR USERNAME
    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    final userName = userDoc.data()?["userName"] ?? "Usuário";

    await FirebaseFirestore.instance.collection("reports").add({
      "description": controller.text.trim(),
      "category": selectedCategory,
      "imageBase64": imageBase64 ?? "",
      "userId": user.uid,
      "userName": userName,
      "likesCount": 0,
      "commentsCount": 0,
      "lat": 0,
      "lng": 0,
      "createdAt": Timestamp.now(),
    });

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Criar Report")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: ListView(
          children: [

            if (imageBase64 != null)
              Image.memory(base64Decode(imageBase64!)),

            ElevatedButton.icon(
              onPressed: pickImage,
              icon: const Icon(Icons.image),
              label: const Text("Adicionar imagem"),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField(
              value: selectedCategory,
              items: [
                "Infraestrutura",
                "Segurança",
                "Iluminação",
                "Limpeza",
                "Outros"
              ]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => selectedCategory = v!),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Descrição",
              ),
              maxLines: 4,
            ),

            const SizedBox(height: 20),

            loading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: createReport,
                    child: const Text("Publicar"),
                  ),
          ],
        ),
      ),
    );
  }
}
