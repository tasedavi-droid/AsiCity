import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/report_model.dart';
import '../services/report_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa de Reports"),
      ),

      body: StreamBuilder<List<ReportModel>>(
        stream: ReportService().getReports(),

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum report encontrado"));
          }

          final reports = snapshot.data!;

          final Set<Marker> markers = reports.map((report) {
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
            myLocationButtonEnabled: true,
          );
        },
      ),
    );
  }
}