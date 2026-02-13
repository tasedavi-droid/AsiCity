import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class CommentsScreen extends StatefulWidget {
  final String reportId;

  const CommentsScreen({super.key, required this.reportId});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {

  final controller = TextEditingController();

  Future sendComment() async {

    if (controller.text.trim().isEmpty) return;

    await FirebaseFirestore.instance
        .collection("reports")
        .doc(widget.reportId)
        .collection("comments")
        .add({
      "text": controller.text.trim(),
      "userId": AuthService().uid,
      "createdAt": Timestamp.now(),
    });

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Comentários")),

      body: SafeArea(
        child: Column(
          children: [

            /// LISTA
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("reports")
                    .doc(widget.reportId)
                    .collection("comments")
                    .orderBy("createdAt", descending: true)
                    .snapshots(),

                builder: (_, snapshot) {

                  if (!snapshot.hasData) return const SizedBox();

                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    reverse: true,
                    itemCount: docs.length,
                    itemBuilder: (_, i) {

                      final data = docs[i];

                      return ListTile(
                        title: Text(data["text"]),
                      );
                    },
                  );
                },
              ),
            ),

            /// INPUT
            Padding(
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),

              child: Row(
                children: [

                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: "Escreva um comentário...",
                      ),
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: sendComment,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}