import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth_service.dart';
import '../services/notification_service.dart';

class CommentsScreen extends StatefulWidget {

  final String reportId;

  const CommentsScreen({super.key, required this.reportId});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {

  final controller = TextEditingController();

  Future sendComment() async {

    final user = AuthService().currentUser;
    if (user == null) return;

    if (controller.text.trim().isEmpty) return;

    final reportDoc = await FirebaseFirestore.instance
        .collection("reports")
        .doc(widget.reportId)
        .get();

    final reportData = reportDoc.data()!;
    final ownerId = reportData["userId"];

    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    final userName = userDoc["userName"] ?? "Usuário";

    /// 🔥 Salvar comentário
    await FirebaseFirestore.instance
        .collection("reports")
        .doc(widget.reportId)
        .collection("comments")
        .add({
      "userName": userName,
      "text": controller.text.trim(),
      "createdAt": Timestamp.now(),
    });

    /// 🔥 Atualizar contador
    await FirebaseFirestore.instance
        .collection("reports")
        .doc(widget.reportId)
        .update({
      "commentsCount": FieldValue.increment(1)
    });

    /// 🔔 Enviar notificação
    if (ownerId != user.uid) {

      await NotificationService().sendNotification(
        toUserId: ownerId,
        title: "Novo comentário",
        message: "$userName comentou no seu report",
        reportId: widget.reportId,
      );
    }

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Comentários")),

      body: Column(
        children: [

          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("reports")
                  .doc(widget.reportId)
                  .collection("comments")
                  .orderBy("createdAt")
                  .snapshots(),

              builder: (_, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (_, i) {

                    final data = docs[i];

                    return ListTile(
                      title: Text(data["userName"]),
                      subtitle: Text(data["text"]),
                    );
                  },
                );
              },
            ),
          ),

          Row(
            children: [

              Expanded(
                child: TextField(controller: controller),
              ),

              IconButton(
                icon: const Icon(Icons.send),
                onPressed: sendComment,
              )
            ],
          )
        ],
      ),
    );
  }
}
