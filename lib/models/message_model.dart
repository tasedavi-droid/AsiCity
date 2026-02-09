class MessageModel {
  String text;
  String userId;
  DateTime time;

  MessageModel({
    required this.text,
    required this.userId,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      "text": text,
      "userId": userId,
      "time": time.toIso8601String(),
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      text: map["text"],
      userId: map["userId"],
      time: DateTime.parse(map["time"]),
    );
  }
}
