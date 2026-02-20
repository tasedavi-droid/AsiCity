import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  String? currentUserName;

  Stream<User?> get authStateChanges =>
      _auth.authStateChanges();

  /// LOGIN
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {

      final cred =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _loadUsername(cred.user!.uid);

      return null;

    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  /// REGISTER
  Future<String?> register({
    required String email,
    required String password,
  }) async {
    try {

      final cred =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _db.collection("users")
          .doc(cred.user!.uid)
          .set({
        "email": email,
        "username": "",
      });

      return null;

    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  /// SALVAR USERNAME
  Future<void> updateUsername(String name) async {

    final user = currentUser;
    if (user == null) return;

    await _db.collection("users")
        .doc(user.uid)
        .set({
      "username": name,
      "email": user.email,
    }, SetOptions(merge: true));

    currentUserName = name;
  }

  /// usado internamente
  Future<void> _loadUsername(String uid) async {

    final doc =
        await _db.collection("users").doc(uid).get();

    currentUserName = doc.data()?["username"];
  }

  Future<String?> getUsername(String uid) async {
    final doc =
        await _db.collection("users").doc(uid).get();
    return doc.data()?["username"];
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
