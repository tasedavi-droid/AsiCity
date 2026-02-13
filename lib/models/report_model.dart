import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {

  final String id;
  final String category;
  final String description;
  final double lat;
  final double lng;
  final String? userEmail;
  final String? imageUrl;
  final Timestamp? createdAt;

  ReportModel({
    required this.id,
    required this.category,
    required this.description,
    required this.lat,
    required this.lng,
    this.userEmail,
    this.imageUrl,
    this.createdAt,
  });

  factory ReportModel.fromFirestore(DocumentSnapshot doc) {

    final data = doc.data() as Map<String, dynamic>;

    return ReportModel(
      id: doc.id,
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      lat: (data['lat'] ?? 0).toDouble(),
      lng: (data['lng'] ?? 0).toDouble(),
      userEmail: data['userEmail'],
      imageUrl: data['imageUrl'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "category": category,
      "description": description,
      "lat": lat,
      "lng": lng,
      "userEmail": userEmail,
      "imageUrl": imageUrl,
      "createdAt": FieldValue.serverTimestamp(),
    };
  }
}