import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("reports")
            .snapshots(),

        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(-23.5, -46.6),
              initialZoom: 12,
            ),

            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png",
                subdomains: const ['a','b','c'],
              ),

              MarkerLayer(
                markers: docs.map((doc) {
                  final data = doc.data();

                  final lat = (data["lat"] as num?)?.toDouble();
                  final lng = (data["lng"] as num?)?.toDouble();

                  if (lat == null || lng == null) {
                    return const Marker(
                      point: LatLng(0, 0),
                      width: 0,
                      height: 0,
                      child: SizedBox(),
                    );
                  }

                  return Marker(
                    point: LatLng(lat, lng),
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}