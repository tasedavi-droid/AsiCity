import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/comment_service.dart';

class CommentTile extends StatefulWidget {
  final String reportId;
  final QueryDocumentSnapshot<Map<String, dynamic>> comment;

  const CommentTile({
    super.key,
    required this.reportId,
    required this.comment,
  });

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  final controller = TextEditingController();
  final service = CommentService();

  bool showReply = false;

  @override
  Widget build(BuildContext context) {
    final commentId = widget.comment.id;
    final data = widget.comment.data();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(data["text"] ?? ""),
          trailing: TextButton(
            child: const Text("Responder"),
            onPressed: () {
              setState(() => showReply = !showReply);
            },
          ),
        ),

        /// 🔥 LISTA DE REPLIES
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: service.getReplies(widget.reportId, commentId),
          builder: (_, snapshot) {
            if (!snapshot.hasData) return const SizedBox();

            final replies = snapshot.data!.docs;

            return Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Column(
                children: replies.map((reply) {
                  final replyData = reply.data();

                  return ListTile(
                    title: Text(replyData["text"] ?? ""),
                  );
                }).toList(),
              ),
            );
          },
        ),

        /// INPUT REPLY
        if (showReply)
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Responder...",
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    if (controller.text.trim().isEmpty) return;

                    await service.createReply(
                      widget.reportId,
                      commentId,
                      controller.text.trim(),
                    );

                    controller.clear();
                  },
                )
              ],
            ),
          ),
      ],
    );
  }
}