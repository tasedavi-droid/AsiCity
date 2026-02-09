import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../services/report_service.dart';
import '../models/report_model.dart';

class CreateReportScreen extends StatefulWidget {
  const CreateReportScreen({super.key});

  @override
  State<CreateReportScreen> createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReportScreen> {
  final desc = TextEditingController();
  File? image;

  final picker = ImagePicker();
  final locationService = LocationService();
  final storage = StorageService();
  final reportService = ReportService();

  Future pickImage() async {
    final img = await picker.pickImage(source: ImageSource.camera);
    if (img != null) {
      setState(() => image = File(img.path));
    }
  }

  Future submit() async {
    if (image == null) return;

    final pos = await locationService.getLocation();
    final url = await storage.uploadImage(image!);

    final report = ReportModel(
      description: desc.text,
      imageUrl: url,
      lat: pos.latitude,
      lng: pos.longitude,
      userId: FirebaseAuth.instance.currentUser!.uid,
    );

    await reportService.createReport(report);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Novo Reporte")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: desc,
              decoration: const InputDecoration(labelText: "Descrição"),
            ),
            const SizedBox(height: 10),

            image != null
                ? Image.file(image!, height: 150)
                : const Text("Nenhuma imagem"),

            ElevatedButton(
                onPressed: pickImage, child: const Text("Tirar Foto")),

            ElevatedButton(
                onPressed: submit, child: const Text("Enviar Reporte"))
          ],
        ),
      ),
    );
  }
}
