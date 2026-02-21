import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {

  final String id;
  final String category;
  final String description;
  final String userId;
  final String userName;
  final int likesCount;
  final int commentsCount;
  final Timestamp createdAt;

  ReportModel({
    required this.id,
    required this.category,
    required this.description,
    required this.userId,
    required this.userName,
    required this.createdAt,
    this.likesCount = 0,
    this.commentsCount = 0,
  });

  /// FIRESTORE -> MODEL
  factory ReportModel.fromFirestore(DocumentSnapshot doc) {

    final data = doc.data() as Map<String, dynamic>? ?? {};

    return ReportModel(
      id: doc.id,
      category: data["category"] ?? "",
      description: data["description"] ?? "",
      userId: data["userId"] ?? "",
      userName: data["userName"] ?? "Usuário",
      likesCount: data["likesCount"] ?? 0,
      commentsCount: data["commentsCount"] ?? 0,
      createdAt: data["createdAt"] ?? Timestamp.now(),
    );
  }

  /// MODEL -> FIRESTORE
  Map<String, dynamic> toMap() {
    return {
      "category": category,
      "description": description,
      "userId": userId,
      "userName": userName,
      "likesCount": likesCount,
      "commentsCount": commentsCount,
      "createdAt": createdAt,
    };
  }
}