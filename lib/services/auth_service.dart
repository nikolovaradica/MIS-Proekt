import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }

  Future<User?> register(String email, String password, String firstName, String lastName, DateTime dateOfBirth) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "dateOfBirth": dateOfBirth.toIso8601String(),
          "createdAt": FieldValue.serverTimestamp(),
        });
      }
      return user;
    } catch (e) {
      print("Registration failed: $e");
      return null;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> reauthenticate(String email, String password) async {
    final user = _auth.currentUser;
    try {
      final credential = EmailAuthProvider.credential(email: email, password: password);
      await user!.reauthenticateWithCredential(credential);
      // return await _auth.currentUser!.reauthenticateWithCredential(credential);
    } catch (e) {
      throw FirebaseAuthException(code: "Reauthentication failed: ${e.toString()}");
    }
  }
}