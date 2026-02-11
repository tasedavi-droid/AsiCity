import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get authState => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  String get uid {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Usuário não está logado");
    }
    return user.uid;
  }

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> register(String email, String password, String name) async {

    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _db.collection("users").doc(cred.user!.uid).set({
      "name": name,
      "email": email,
      "createdAt": Timestamp.now()
    });
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}