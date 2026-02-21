import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

class ChatService {

  final _db = FirebaseFirestore.instance;

  ///  GERAR ID DO CHAT ENTRE DOIS USUÁRIOS
  String generateChatId(String user1, String user2) {
    return user1.hashCode <= user2.hashCode
        ? "${user1}_$user2"
        : "${user2}_$user1";
  }

  ///  ENVIAR MENSAGEM
  Future<void> sendMessage({
    required String receiverId,
    required String message,
  }) async {

    final user = AuthService().currentUser;
    if (user == null) return;

    final chatId = generateChatId(user.uid, receiverId);

    await _db
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .add({
      "senderId": user.uid,
      "message": message,
      "createdAt": Timestamp.now(),
    });
  }

  ///  STREAM DE MENSAGENS
  Stream<QuerySnapshot> getMessages(String receiverId) {

    final user = AuthService().currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    final chatId = generateChatId(user.uid, receiverId);

    return _db
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("createdAt", descending: false)
        .snapshots();
  }
}
