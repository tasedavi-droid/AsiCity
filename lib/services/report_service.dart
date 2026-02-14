import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/report_model.dart';
import 'auth_service.dart';

class ReportService {

  final _db = FirebaseFirestore.instance;

  /// 🔥 CRIAR
  Future createReport(Map<String, dynamic> data) async {
    await _db.collection("reports").add(data);
  }

  /// 🔥 EDITAR
  Future updateReport({
    required String reportId,
    required String category,
    required String description,
  }) async {

    await _db.collection("reports").doc(reportId).update({
      "category": category,
      "description": description,
    });
  }

  /// 🔥 EXCLUIR
  Future deleteReport(String reportId) async {

    await _db.collection("reports").doc(reportId).delete();
  }

  /// 🔥 STREAM
  Stream<List<ReportModel>> getReports({String? category}) {

    Query query = _db
        .collection("reports")
        .orderBy("createdAt", descending: true);

    if (category != null && category != "Todos") {
      query = query.where("category", isEqualTo: category);
    }

    return query.snapshots().map((snapshot) {

      return snapshot.docs
          .map((doc) => ReportModel.fromFirestore(doc))
          .toList();
    });
  }

  /// 🔥 LIKE
  Future toggleLike(String reportId) async {

    final user = AuthService().currentUser;
    if (user == null) return;

    final likeRef = _db
        .collection("reports")
        .doc(reportId)
        .collection("likes")
        .doc(user.uid);

    final doc = await likeRef.get();

    if (doc.exists) {

      await likeRef.delete();

      _db.collection("reports").doc(reportId).update({
        "likesCount": FieldValue.increment(-1)
      });

    } else {

      await likeRef.set({});

      _db.collection("reports").doc(reportId).update({
        "likesCount": FieldValue.increment(1)
      });
    }
  }
}
