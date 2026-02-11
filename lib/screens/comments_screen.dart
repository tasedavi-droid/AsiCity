import 'package:asicity/reply_section.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/comment_service.dart';

class CommentsScreen extends StatefulWidget {

  final String reportId;

  const CommentsScreen({super.key, required this.reportId});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {

  final controller = TextEditingController();
  final service = CommentService();

  Future sendComment() async {

    if (controller.text.trim().isEmpty) return;

    await service.createComment(widget.reportId, controller.text.trim());

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Comentários")),

      body: Column(
        children: [

          /// LISTA COMENTÁRIOS
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: service.getComments(widget.reportId),
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final comments = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {

                    final comment = comments[index];

                    return ListTile(
                      title: Text(comment["text"]),
                      subtitle: ReplySection(
                        reportId: widget.reportId,
                        commentId: comment.id,
                      ),
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
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Comentar...",
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendComment,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}