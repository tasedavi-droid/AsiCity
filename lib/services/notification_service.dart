import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {

  final _db = FirebaseFirestore.instance;

  Future sendNotification({
    required String toUserId,
    required String title,
    required String message,
    required String reportId,
  }) async {

    await _db.collection("notifications").add({
      "toUserId": toUserId,
      "title": title,
      "message": message,
      "reportId": reportId,
      "read": false,
      "createdAt": Timestamp.now(),
    });
  }
}
