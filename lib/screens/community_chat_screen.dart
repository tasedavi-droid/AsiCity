import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth_service.dart';

class CommunityChatScreen extends StatefulWidget {
  const CommunityChatScreen({super.key});

  @override
  State<CommunityChatScreen> createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen> {

  final messageController = TextEditingController();
  final auth = AuthService();

  Future<void> sendMessage() async {

    final user = auth.currentUser;
    if (user == null) return;

    if (messageController.text.trim().isEmpty) return;

    /// Buscar username
    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    final userName = userDoc.data()?["userName"] ?? "Usuário";

    await FirebaseFirestore.instance
        .collection("community_messages")
        .add({
      "userId": user.uid,
      "userName": userName,
      "message": messageController.text.trim(),
      "createdAt": Timestamp.now(),
    });

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Comunidade")),

      body: Column(
        children: [

          /// LISTA MENSAGENS
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("community_messages")
                  .orderBy("createdAt", descending: true)
                  .snapshots(),

              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: (_, i) {

                    final data = docs[i].data() as Map<String, dynamic>;

                    return ListTile(

                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),

                      title: Text(
                        data["userName"] ?? "Usuário",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      subtitle: Text(data["message"] ?? ""),
                    );
                  },
                );
              },
            ),
          ),

          /// INPUT
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: "Digite uma mensagem...",
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
