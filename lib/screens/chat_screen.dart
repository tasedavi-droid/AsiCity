import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String reportId;
  const ChatScreen({super.key, required this.reportId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();
  final user = AuthService().currentUser;

  Future sendMessage() async {
    if (controller.text.trim().isEmpty) return;

    await FirebaseFirestore.instance
        .collection("reports")
        .doc(widget.reportId)
        .collection("chat")
        .add({
      "text": controller.text.trim(),
      "userEmail": user?.email,
      "createdAt": Timestamp.now(),
    });

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat do Report")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("reports")
                  .doc(widget.reportId)
                  .collection("chat")
                  .orderBy("createdAt")
                  .snapshots(),
              builder: (_, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: messages.length,
                  itemBuilder: (_, i) {
                    final msg = messages[i];
                    final data = msg.data() as Map<String, dynamic>;
                    final isMe = data["userEmail"] == user?.email;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: MessageBubble(
                        message: data["text"] ?? "",
                        userName: data["userEmail"] ?? "Usuário",
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
                Expanded(child: TextField(controller: controller, decoration: const InputDecoration(hintText: "Mensagem..."))),
                IconButton(icon: const Icon(Icons.send), onPressed: sendMessage)
              ],
            ),
          )
        ],
      ),
    );
  }
}
