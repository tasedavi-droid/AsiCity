import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;

  const MessageBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      color: Colors.blue[100],
      child: Text(text),
    );
  }
}
