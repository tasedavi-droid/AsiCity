import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

class LikeService {

  final _db = FirebaseFirestore.instance;

  Future<void> toggleLike(String reportId) async {

    final user = AuthService().currentUser;
    if (user == null) return;

    final ref = _db
        .collection("reports")
        .doc(reportId)
        .collection("likes")
        .doc(user.uid);

    final doc = await ref.get();

    if (doc.exists) {
      await ref.delete();
    } else {
      await ref.set({"createdAt": Timestamp.now()});
    }
  }

  Stream<int> likeCount(String reportId) {

    return _db
        .collection("reports")
        .doc(reportId)
        .collection("likes")
        .snapshots()
        .map((s) => s.docs.length);
  }
}
