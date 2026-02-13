import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/comment_service.dart';

class ReplySection extends StatefulWidget {
  final String reportId;
  final String commentId;

  const ReplySection({
    super.key,
    required this.reportId,
    required this.commentId,
  });

  @override
  State<ReplySection> createState() => _ReplySectionState();
}

class _ReplySectionState extends State<ReplySection> {
  final controller = TextEditingController();
  final service = CommentService();

  bool showReply = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          child: const Text("Responder"),
          onPressed: () {
            setState(() => showReply = !showReply);
          },
        ),

        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: service.getReplies(widget.reportId, widget.commentId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox();

            final replies = snapshot.data!.docs;

            return Column(
              children: replies.map((reply) {
                final data = reply.data();

                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(data["text"] ?? ""),
                );
              }).toList(),
            );
          },
        ),

        if (showReply)
          Row(
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
                    widget.commentId,
                    controller.text.trim(),
                  );

                  controller.clear();
                },
              )
            ],
          )
      ],
    );
  }
}