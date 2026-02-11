import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {

  final String id;
  final String description;
  final String imageBase64;
  final String userId;
  final double lat;
  final double lng;
  final int likes;
  final List likedBy;
  final String category;
  final String status;
  final DateTime createdAt;

  ReportModel({
    required this.id,
    required this.description,
    required this.imageBase64,
    required this.userId,
    required this.lat,
    required this.lng,
    required this.likes,
    required this.likedBy,
    required this.category,
    required this.status,
    required this.createdAt,
  });

  factory ReportModel.fromMap(String id, Map<String, dynamic> map) {
    return ReportModel(
      id: id,
      description: map["description"] ?? "",
      imageBase64: map["imageBase64"] ?? "",
      userId: map["userId"] ?? "",
      lat: (map["lat"] ?? 0).toDouble(),
      lng: (map["lng"] ?? 0).toDouble(),
      likes: map["likes"] ?? 0,
      likedBy: map["likedBy"] ?? [],
      category: map["category"] ?? "Outros",
      status: map["status"] ?? "Pendente",
      createdAt: (map["createdAt"] as Timestamp).toDate(),
    );
  }
}