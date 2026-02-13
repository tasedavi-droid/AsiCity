import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/report_model.dart';
import 'auth_service.dart';

class ReportService {

  final _db = FirebaseFirestore.instance;

  /// 🔥 CRIAR REPORT
  Future<void> createReport({
    required String category,
    required String description,
    required double lat,
    required double lng,
    String? imageUrl,
  }) async {

    final user = AuthService().currentUser;
    if (user == null) return;

    if (description.trim().isEmpty) return;

    final report = ReportModel(
      id: "",
      category: category,
      description: description.trim(),
      lat: lat,
      lng: lng,
      userEmail: user.email,
      imageUrl: imageUrl,
      createdAt: Timestamp.now(),
    );

    await _db.collection("reports").add(report.toMap());
  }

  /// 🔥 STREAM REPORTS
  Stream<List<ReportModel>> getReports({String? category}) {

    Query query = _db
        .collection("reports")
        .orderBy("createdAt", descending: true);

    if (category != null && category != "Todos") {
      query = query.where("category", isEqualTo: category);
    }

    return query.snapshots().map((snapshot) {

      return snapshot.docs.map((doc) {
        return ReportModel.fromFirestore(doc);
      }).toList();

    });
  }
}