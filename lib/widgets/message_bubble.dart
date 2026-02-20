import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {

  final String message;
  final String userName;
  final bool isMe;
  final String? time;

  const MessageBubble({
    super.key,
    required this.message,
    required this.userName,
    required this.isMe,
    this.time,
  });

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment:
          isMe ? Alignment.centerRight : Alignment.centerLeft,

      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe
              ? Colors.blue
              : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(12),
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
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

            if (time != null)
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  time!,
                  style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white70),
                ),
              )
          ],
        ),
      ),
    );
  }
}
