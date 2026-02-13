import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {

  final String message;
  final String userName;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.userName,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,

      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,

        children: [

          if (!isMe)
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.indigo,
              child: Text(userName[0].toUpperCase()),
            ),

          const SizedBox(width: 8),

          Container(
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(maxWidth: 260),
            decoration: BoxDecoration(
              color: isMe
                  ? Colors.indigo
                  : const Color(0xFF1F2937),

              borderRadius: BorderRadius.circular(16),
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
        ],
      ),
    );
  }
}