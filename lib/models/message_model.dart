class MessageModel {
  final String id;
  final String text;
  final String userId;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.text,
    required this.userId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        "text": text,
        "userId": userId,
        "createdAt": createdAt,
      };

  factory MessageModel.fromMap(String id, Map<String, dynamic> map) {
    return MessageModel(
      id: id,
      text: map["text"],
      userId: map["userId"],
      createdAt: map["createdAt"].toDate(),
    );
  }
}