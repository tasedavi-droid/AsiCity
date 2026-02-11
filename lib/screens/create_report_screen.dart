import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

import '../services/auth_service.dart';

class CreateReportScreen extends StatefulWidget {
  const CreateReportScreen({super.key});

  @override
  State<CreateReportScreen> createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReportScreen> {

  final controller = TextEditingController();
  File? selectedImage;

  String selectedCategory = "Infraestrutura";

  final picker = ImagePicker();

  Future<void> pickImage() async {
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() => selectedImage = File(image.path));
    }
  }

  Future<void> createReport() async {

    final auth = AuthService();
    if (auth.currentUser == null) return;

    final pos = await Geolocator.getCurrentPosition();

    String base64Img = "";

    if (selectedImage != null) {
      final bytes = await selectedImage!.readAsBytes();
      base64Img = base64Encode(bytes);
    }

    await FirebaseFirestore.instance.collection("reports").add({
      "description": controller.text,
      "imageBase64": base64Img,
      "userId": auth.uid,
      "lat": pos.latitude,
      "lng": pos.longitude,
      "likes": 0,
      "likedBy": [],
      "category": selectedCategory,
      "status": "Pendente",
      "createdAt": Timestamp.now(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Novo Report")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            DropdownButton<String>(
              value: selectedCategory,
              items: [
                "Infraestrutura",
                "Segurança",
                "Iluminação",
                "Limpeza",
                "Outros"
              ].map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Text(cat),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedCategory = value!);
              },
            ),

            TextField(controller: controller),

            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Foto"),
            ),

            ElevatedButton(
              onPressed: createReport,
              child: const Text("Enviar"),
            )
          ],
        ),
      ),
    );
  }
}