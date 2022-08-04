import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAuth {
  static bool isAdmin = false;
  static Stream<bool> isAuthenticated() {
    return FirebaseAuth.instance
        .authStateChanges()
        .where((currentUser) => currentUser != null)
        .map((currentUser) {
      if (currentUser != null) {
        currentUser.getIdTokenResult().then((value) {
          if (value.claims != null) {
            isAdmin = value.claims!['admin'] ?? false;
          } else {
            isAdmin = false;
          }
        });
        return true;
      }
      return false;
    });
  }

  static Future<bool?> loginEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw ('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw ('Wrong password provided for that user.');
      }
    }
    return true;
  }

  static Future logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      return;
    }
  }

  static Future<String?> getToken() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await _getToken(user);
    } else {
      await UserAuth.isAuthenticated().first;
      user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return await _getToken(user);
      } else {
        await logout();
        return null;
      }
    }
  }

  static Future<String?> getUserImageUrl() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.photoURL;
    } else {
      return null;
    }
  }

  static Future<String?> getUserDisplayName() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.displayName;
    } else {
      return null;
    }
  }

  static Future<String?> getUserEmail() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.email;
    } else {
      return null;
    }
  }

  static Future<String?> getUserUid() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

  static Future<String> _getToken(User user) async {
    var token = await user.getIdToken();
    debugPrint('Firebase token: Bearer $token');
    return token;
  }
}
