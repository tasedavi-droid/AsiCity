import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

class NotificationService {
  final _messaging = FirebaseMessaging.instance;

  Future init() async {
    await _messaging.requestPermission();

    String? token = await _messaging.getToken();

    if (token != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(AuthService().uid)
          .update({"fcmToken": token});
    }
  }
}