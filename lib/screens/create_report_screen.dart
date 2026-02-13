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
  bool loading = false;

  double? lat;
  double? lng;

  final picker = ImagePicker();

  Future<void> pickImage() async {
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() => selectedImage = File(image.path));
    }
  }

  Future<void> getLocation() async {
    await Geolocator.requestPermission();
    final position = await Geolocator.getCurrentPosition();
    lat = position.latitude;
    lng = position.longitude;
  }

  Future<void> createReport() async {

    final auth = AuthService();
    final user = auth.currentUser;

    if (user == null) return;
    if (controller.text.trim().isEmpty) return;

    setState(() => loading = true);

    try {

      await getLocation();

      String imageBase64 = "";

      if (selectedImage != null) {
        final bytes = await selectedImage!.readAsBytes();
        imageBase64 = base64Encode(bytes);
      }

      await FirebaseFirestore.instance.collection("reports").add({
        "description": controller.text.trim(),
        "imageBase64": imageBase64,
        "userId": user.uid,
        "userEmail": user.email ?? "Usuário",
        "lat": lat,
        "lng": lng,
        "likes": 0,
        "likedBy": [],
        "category": "Outros",
        "status": "Pendente",
        "createdAt": Timestamp.now(),
      });

      if (!mounted) return;
      Navigator.pop(context);

    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Novo Report")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            if (selectedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(selectedImage!, height: 180),
              ),

            ElevatedButton.icon(
              onPressed: pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text("Adicionar foto"),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Descrição",
              ),
            ),

            const SizedBox(height: 20),

            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: createReport,
                    child: const Text("Enviar"),
                  ),
          ],
        ),
      ),
    );
  }
}