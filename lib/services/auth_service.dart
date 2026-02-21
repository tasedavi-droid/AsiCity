import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// USER ATUAL
  User? get currentUser => _auth.currentUser;

  /// STREAM LOGIN
  Stream<User?> get authStateChanges =>
      _auth.authStateChanges();

  /// ✅ LOGIN 
  Future<User?> login(String email, String password) async {

    final cred =
        await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return cred.user;
  }

  /// REGISTER
  Future<User?> register(
    String email,
    String password,
    String username,
  ) async {

    final cred =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _db.collection("users").doc(cred.user!.uid).set({
      "username": username,
      "email": email,
      "createdAt": Timestamp.now(),
    });

    return cred.user;
  }

  /// LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// PEGAR USERNAME
  Future<String?> getUsername(String uid) async {

    final doc =
        await _db.collection("users").doc(uid).get();

    if (!doc.exists) return null;

    final data = doc.data();
    if (data == null) return null;

    return data["username"];
  }

  /// ATUALIZAR USERNAME
  Future<void> updateUsername(String username) async {

    final user = currentUser;
    if (user == null) return;

    await _db.collection("users").doc(user.uid).update({
      "username": username,
    });
  }
}