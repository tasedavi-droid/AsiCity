import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';
import 'auth_service.dart';

class ChatService {
  final _db = FirebaseFirestore.instance;

  Stream<List<MessageModel>> getMessages() {
    return _db
        .collection("chat")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => MessageModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future sendMessage(String text) async {
    await _db.collection("chat").add({
      "text": text,
      "userId": AuthService().uid,
      "createdAt": DateTime.now()
    });
  }
}