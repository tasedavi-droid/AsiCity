import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../widgets/message_bubble.dart';

class CommunityChatScreen extends StatefulWidget {
  const CommunityChatScreen({super.key});

  @override
  State<CommunityChatScreen> createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen> {

  final controller = TextEditingController();
  final user = AuthService().currentUser;

  Future sendMessage() async {

    if (controller.text.trim().isEmpty) return;

    await FirebaseFirestore.instance.collection("community_chat").add({
      "text": controller.text.trim(),
      "userEmail": user?.email,
      "createdAt": Timestamp.now(),
    });

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Comunidade")),

      body: Column(
        children: [

          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("community_chat")
                  .orderBy("createdAt")
                  .snapshots(),

              builder: (_, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: messages.length,
                  itemBuilder: (_, i) {

                    final msg = messages[i];
                    final isMe = msg["userEmail"] == user?.email;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: MessageBubble(
                        message: msg["text"],
                        userName: msg["userEmail"] ?? "Usuário",
                        isMe: isMe,
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: controller,
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