import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? lastError; // Add this line

  Future<User?> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      lastError = null;
      return result.user;
    } on FirebaseAuthException catch (e) {
      lastError = e.message;
      return null;
    }
  }

  Future<User?> register(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      lastError = null;
      return result.user;
    } on FirebaseAuthException catch (e) {
      lastError = e.message;
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> get userChanges => _auth.userChanges();

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}