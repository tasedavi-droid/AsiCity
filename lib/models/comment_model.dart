class CommentModel {

  final String id;
  final String text;
  final String userId;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.text,
    required this.userId,
    required this.createdAt,
  });

  factory CommentModel.fromMap(String id, Map<String, dynamic> map) {
    return CommentModel(
      id: id,
      text: map["text"] ?? "",
      userId: map["userId"] ?? "",
      createdAt: map["createdAt"].toDate(),
    );
  }
}