import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {

  final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  /// Inicialização
  Future<void> init() async {
    await _messaging.requestPermission();
  }

  /// 🔥 ESCUTA NOTIFICAÇÕES (CORRIGE ERRO DO MAIN)
  void listenNotifications() {

    FirebaseMessaging.onMessage.listen((message) {
      print("Notificação recebida em foreground");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("Usuário abriu notificação");
    });
  }

  /// salva token do usuário
  Future<void> saveTokenToDatabase(String uid) async {

    final token = await _messaging.getToken();

    if (token == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .set({
      "fcmToken": token,
    }, SetOptions(merge: true));
  }

  /// envio fake (placeholder — apenas remove erro)
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
  }) async {
    print("Notificação enviada para $userId");
  }
}
