import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/report_service.dart';
import '../models/report_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Mapa")),

      body: StreamBuilder<List<ReportModel>>(
        stream: ReportService().getReports(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final reports = snapshot.data!;

          final markers = reports.map((report) {
            return Marker(
              markerId: MarkerId(report.id),
              position: LatLng(report.lat, report.lng),
              infoWindow: InfoWindow(
                title: report.category,
                snippet: report.description,
              ),
            );
          }).toSet();

          return GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(-22.4235, -45.4521),
              zoom: 14,
            ),
            markers: markers,
            myLocationEnabled: true,
          );
        },
      ),
    );
  }
}
