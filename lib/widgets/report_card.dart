import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/report_model.dart';
import '../services/report_service.dart';
import '../services/auth_service.dart';

class ReportCard extends StatelessWidget {

  final ReportModel report;

  const ReportCard({super.key, required this.report});

  Future openMaps() async {
    final url = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=${report.lat},${report.lng}");
    await launchUrl(url);
  }
  

  @override
  Widget build(BuildContext context) {

    Uint8List? imageBytes;

    if (report.imageBase64.isNotEmpty) {
      try {
        imageBytes = base64Decode(report.imageBase64);
      } catch (_) {}
    }

    final liked = report.likedBy.contains(AuthService().uid);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          if (imageBytes != null)
            Image.memory(imageBytes),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(report.description),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text("Categoria: ${report.category}"),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text("Status: ${report.status}"),
          ),

          Row(
            children: [

              IconButton(
                icon: Icon(
                  liked ? Icons.favorite : Icons.favorite_border,
                  color: liked ? Colors.red : null,
                ),
                onPressed: () {
                  ReportService().toggleLike(report.id, report.likedBy);
                },
              ),

              Text("${report.likes}"),

              IconButton(
                icon: const Icon(Icons.map),
                onPressed: openMaps,
              ),
            ],
          )
        ],
      ),
    );
  }
}