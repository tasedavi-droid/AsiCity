import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {

  final String message;
  final bool isMe;
  final String userName;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment:
          isMe ? Alignment.centerRight : Alignment.centerLeft,

      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(14),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              userName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 4),

            Text(message),
          ],
        ),
      ),
    );
  }
}
