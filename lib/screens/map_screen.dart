import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {

  final double lat;
  final double lng;

  const MapScreen({
    super.key,
    required this.lat,
    required this.lng,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Mapa")),

      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(lat, lng),
          initialZoom: 16,
        ),

        children: [

          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),

          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(lat, lng),
                child: const Icon(Icons.location_pin, size: 40),
              )
            ],
          )
        ],
      ),
    );
  }
}