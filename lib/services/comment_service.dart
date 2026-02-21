import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentService {

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  ///  CRIAR COMENTÁRIO
  Future createComment(String reportId, String text) async {

    final uid = _auth.currentUser!.uid;

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

  ///  LISTAR COMENTÁRIOS
  Stream<QuerySnapshot<Map<String, dynamic>>> getComments(String reportId) {

    return _db
        .collection("reports")
        .doc(reportId)
        .collection("comments")
        .orderBy("createdAt", descending: false)
        .snapshots();
  }

  ///  CRIAR REPLY
  Future createReply(
      String reportId,
      String commentId,
      String text,
      ) async {

    final uid = _auth.currentUser!.uid;

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

  ///  LISTAR REPLIES
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
}