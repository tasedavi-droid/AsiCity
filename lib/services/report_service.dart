import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/report_model.dart';

class ReportService {

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// STREAM REPORTS
  Stream<List<ReportModel>> getReports() {
    return _db.collection("reports").snapshots().map((snapshot) {

      final list = snapshot.docs
          .map((doc) => ReportModel.fromFirestore(doc))
          .toList();

      /// ordenação segura
      list.sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      );

      return list;
    });
  }

  /// CREATE REPORT
  Future<void> createReport(ReportModel report) async {
    await _db.collection("reports").add(report.toMap());
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

    final likeDoc = await likeRef.get();

    if (likeDoc.exists) return;

    await likeRef.set({
      "createdAt": Timestamp.now(),
    });

    await _db.collection("reports").doc(reportId).update({
      "likesCount": FieldValue.increment(1),
    });
  }

  /// EDITAR
  Future<void> editReport(
      String reportId,
      String description,
      String category,
      ) async {

    await _db.collection("reports").doc(reportId).update({
      "description": description,
      "category": category,
      "editedAt": Timestamp.now(),
    });
  }

  /// DELETE
  Future<void> deleteReport(String reportId) async {
    await _db.collection("reports").doc(reportId).delete();
  }
}