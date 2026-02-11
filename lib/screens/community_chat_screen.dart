import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class CommunityChatScreen extends StatefulWidget {
  const CommunityChatScreen({super.key});

  @override
  State<CommunityChatScreen> createState() => _CommunityChatState();
}

class _CommunityChatState extends State<CommunityChatScreen> {

  final controller = TextEditingController();

  Future sendMessage() async {

    final auth = AuthService();

    if (controller.text.trim().isEmpty) return;

    await FirebaseFirestore.instance.collection("community_messages").add({
      "text": controller.text.trim(),
      "userId": auth.uid,
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
                  .collection("community_messages")
                  .orderBy("createdAt", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {

                if (!snapshot.hasData) return const SizedBox();

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    final msg = docs[i];

                    return ListTile(
                      title: Text(msg["text"]),
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