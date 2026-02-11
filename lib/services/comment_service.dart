import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

class CommentService {

  final _db = FirebaseFirestore.instance;

  /// LISTAR COMENTÁRIOS
  Stream<QuerySnapshot<Map<String, dynamic>>> getComments(String reportId) {

    return _db
        .collection("reports")
        .doc(reportId)
        .collection("comments")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  /// CRIAR COMENTÁRIO
  Future createComment(String reportId, String text) async {

    final uid = AuthService().uid;

    await _db
        .collection("reports")
        .doc(reportId)
        .collection("comments")
        .add({
      "text": text,
      "userId": uid,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// LISTAR REPLIES
  Stream<QuerySnapshot<Map<String, dynamic>>> getReplies(
      String reportId,
      String commentId,
      ) {

    return _db
        .collection("reports")
        .doc(reportId)
        .collection("comments")
        .doc(commentId)
        .collection("replies")
        .orderBy("createdAt")
        .snapshots();
  }

  /// CRIAR REPLY
  Future createReply(
      String reportId,
      String commentId,
      String text,
      ) async {

    final uid = AuthService().uid;

    await _db
        .collection("reports")
        .doc(reportId)
        .collection("comments")
        .doc(commentId)
        .collection("replies")
        .add({
      "text": text,
      "userId": uid,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }
}