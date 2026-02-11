import 'package:flutter/material.dart';
import '../services/chat_service.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatState();
}

class _ChatState extends State<ChatScreen> {
  final controller = TextEditingController();

  void send() async {
    if (controller.text.trim().isEmpty) return;

    await ChatService().sendMessage(controller.text.trim());
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat da Comunidade")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: ChatService().getMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (_, i) {
                    return MessageBubble(message: messages[i]);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(controller: controller),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: send,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}