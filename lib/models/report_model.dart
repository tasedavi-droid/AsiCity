import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final String id;
  final String category;
  final String description;
  final double lat;
  final double lng;
  final String? userId;
  final String? userName;
  final String? imageBase64;
  final int likesCount;
  final int commentsCount;
  final Timestamp? createdAt;

  ReportModel({
    required this.id,
    required this.category,
    required this.description,
    required this.lat,
    required this.lng,
    this.userId,
    this.userName,
    this.imageBase64,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.createdAt,
  });

  factory ReportModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ReportModel(
      id: doc.id,
      category: data["category"] ?? "",
      description: data["description"] ?? "",
      lat: (data["lat"] ?? 0).toDouble(),
      lng: (data["lng"] ?? 0).toDouble(),
      userId: data["userId"],
      userName: data["userName"],
      imageBase64: data["imageBase64"],
      likesCount: data["likesCount"] ?? 0,
      commentsCount: data["commentsCount"] ?? 0,
      createdAt: data["createdAt"],
    );
  }
}
