import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatelessWidget {
  final msg = TextEditingController();

  ChatScreen({super.key});

  void send() {
    FirebaseFirestore.instance.collection("chat").add({
      "text": msg.text,
      "user": FirebaseAuth.instance.currentUser!.email,
      "time": DateTime.now()
    });

    msg.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat Comunidade")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("chat").snapshots(),
              builder: (_, snapshot) {
                if (!snapshot.hasData) return const SizedBox();

                return ListView(
                  children: snapshot.data!.docs.map((d) {
                    return ListTile(
                      title: Text(d["text"]),
                      subtitle: Text(d["user"]),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          TextField(controller: msg),
          ElevatedButton(onPressed: send, child: const Text("Enviar"))
        ],
      ),
    );
  }
}
