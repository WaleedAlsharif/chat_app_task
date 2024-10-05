import 'package:firebase_auth/firebase_auth.dart';

class AuthService  {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

// sign in user
  Future<UserCredential> signInWithEmailandPassword(
      {required String email, required String password}) async {
    try {
      // sign in
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Sign Up Function
  Future<void> signUp({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      // Handle error
    }
  }

  // Logout Function
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
