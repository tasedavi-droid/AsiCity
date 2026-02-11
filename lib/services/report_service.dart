import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/report_model.dart';
import 'auth_service.dart';

class ReportService {

  final _db = FirebaseFirestore.instance;

  Stream<List<ReportModel>> getReports({String? category}) {

    Query query = _db.collection("reports").orderBy("createdAt", descending: true);

    if (category != null && category != "Todos") {
      query = query.where("category", isEqualTo: category);
    }

    return query.snapshots().map((snap) =>
        snap.docs.map((doc) =>
            ReportModel.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList());
  }

  Future toggleLike(String id, List likedBy) async {

    final uid = AuthService().uid;
    final doc = _db.collection("reports").doc(id);

    if (likedBy.contains(uid)) {
      await doc.update({
        "likes": FieldValue.increment(-1),
        "likedBy": FieldValue.arrayRemove([uid])
      });
    } else {
      await doc.update({
        "likes": FieldValue.increment(1),
        "likedBy": FieldValue.arrayUnion([uid])
      });
    }
  }
}