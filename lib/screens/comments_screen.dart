import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../services/report_service.dart';

class CommentsScreen extends StatefulWidget {

  final String reportId;

  const CommentsScreen({
    super.key,
    required this.reportId,
  });

  @override
  State<CommentsScreen> createState() =>
      _CommentsScreenState();
}

class _CommentsScreenState
    extends State<CommentsScreen> {

  final controller = TextEditingController();
  final db = FirebaseFirestore.instance;

  Future<void> sendComment() async {

    final user = AuthService().currentUser;
    if (user == null) return;

    final username =
        await AuthService().getUsername(user.uid);

    await db
        .collection("reports")
        .doc(widget.reportId)
        .collection("comments")
        .add({
      "text": controller.text,
      "userName": username ?? "Usuário",
      "createdAt": Timestamp.now(),
    });

    await ReportService().addInteraction(
      reportId: widget.reportId,
      userId: user.uid,
      type: "comment",
    );

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Comentários")),

      body: Column(
        children: [

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: db
                  .collection("reports")
                  .doc(widget.reportId)
                  .collection("comments")
                  .orderBy("createdAt")
                  .snapshots(),
              builder: (_, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(
                      child:
                          CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                return ListView(
                  children: docs.map((doc) {

                    final data =
                        doc.data() as Map<String,
                            dynamic>;

                    return ListTile(
                      title: Text(data["userName"]),
                      subtitle: Text(data["text"]),
                    );
                  }).toList(),
                );
              },
            ),
          ),

          Row(
            children: [

              Expanded(
                child: TextField(
                  controller: controller,
                  decoration:
                      const InputDecoration(
                          hintText: "Comentar..."),
                ),
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
