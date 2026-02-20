import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/report_model.dart';

class ReportService {

  final _db = FirebaseFirestore.instance;

  /// STREAM REPORTS
  Stream<List<ReportModel>> getReports() {
    return _db
        .collection("reports")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                ReportModel.fromFirestore(doc))
            .toList());
  }

  /// CRIAR REPORT
  Future<void> createReport(ReportModel report) async {

    await _db.collection("reports").add(
          report.toMap(),
        );
  }

  /// EDITAR REPORT
  Future<void> editReport({
    required String reportId,
    required String description,
    required String category,
  }) async {

    await _db.collection("reports")
        .doc(reportId)
        .update({
      "description": description,
      "category": category,
    });
  }

  /// DELETAR REPORT
  Future<void> deleteReport(String id) async {
    await _db.collection("reports").doc(id).delete();
  }

  /// LIKE ÚNICO
  Future<void> addInteraction({
    required String reportId,
    required String userId,
    required String type,
  }) async {

    final likeRef = _db
        .collection("reports")
        .doc(reportId)
        .collection("likes")
        .doc(userId);

    final alreadyLiked = await likeRef.get();

    if (alreadyLiked.exists) return;

    await likeRef.set({
      "likedAt": Timestamp.now(),
    });

    await _db.collection("reports")
        .doc(reportId)
        .update({
      "likesCount":
          FieldValue.increment(1),
    });
  }
}
