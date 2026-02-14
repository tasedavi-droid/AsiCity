import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// LOGIN
  Future<String?> login({
    required String email,
    required String password,
  }) async {

    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
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
      final credential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      /// cria doc do usuário
      await _db.collection("users").doc(credential.user!.uid).set({
        "userName": "",
        "email": email
      });

      return null;

    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  /// SALVAR USERNAME
  Future<void> saveUserName(String name) async {

    final user = currentUser;
    if (user == null) return;

    await _db.collection("users").doc(user.uid).update({
      "userName": name.trim(),
    });
  }

  /// PEGAR USERNAME
  Future<String?> getUserName() async {

    final user = currentUser;
    if (user == null) return null;

    final doc =
        await _db.collection("users").doc(user.uid).get();

    return doc.data()?['userName'];
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
