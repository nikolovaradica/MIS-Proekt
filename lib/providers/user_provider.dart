import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:lifelog/models/app_user.dart';

class UserProvider with ChangeNotifier {
  AppUser? _user;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser? get user => _user;

  Future<void> loadUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(currentUser.uid).get();
      if (doc.exists) {
        _user = AppUser.fromMap(doc);
        notifyListeners();
      }
    }
  }

  Future<void> updateUser(AppUser appUser) async {
    if (user != null) {
      await _firestore.collection('users').doc(_user!.uid).update(appUser.toMap());
      _user = appUser;
      notifyListeners();
    }
  }
}