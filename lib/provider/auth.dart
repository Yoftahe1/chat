import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  Map<String, dynamic>? _user;
  Future<void> signUp(String email, String username, String password) async {
    var authResult;
    try {
      authResult = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user.uid)
          .set({
        'username': username,
        'email': email.trim(),
        'uid': authResult.user.uid,
      });
      _user = {
        'email': email,
        'username': username,
        'uid': authResult.user.uid,
      };
      notifyListeners();
    } catch (err) {
      throw (err.toString());
    }
  }

  Future<void> signIn(String email, String password) async {
    var authResult;
    try {
      authResult = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user.uid)
          .get()
          .then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          _user = data;
          notifyListeners();
        },
        onError: (e) => throw (e),
      );
    } catch (err) {
      throw (err.toString());
    }
  }

  Map<String, dynamic> get getUser {
    return {..._user!};
  }
}
