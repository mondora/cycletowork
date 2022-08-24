import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserAuth {
  static bool isAdmin = false;
  static final GoogleSignIn _googleSignInForIos = GoogleSignIn(
    clientId: dotenv.env['IOS_FIREBASE_CLIENT_ID']!,
    serverClientId: dotenv.env['IOS_FIREBASE_SERVER_CLIENT_ID']!,
  );
  static final GoogleSignIn _googleSignInForAndroid = GoogleSignIn();

  static Stream<bool> isAuthenticatedStateChanges() {
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

  static Future<void> loginGoogleSignIn() async {
    final GoogleSignInAccount googleSignInAccount = Platform.isAndroid
        ? (await _googleSignInForAndroid.signIn())!
        : (await _googleSignInForIos.signIn())!;
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<bool?> signupEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw (e.code);
      // if (e.code == 'weak-password') {
      //   throw ('The password provided is too weak.');
      // } else if (e.code == 'email-already-in-use') {
      //   throw ('The account already exists for that email.');
      // }
    }
    return true;
  }

  static Future<bool?> loginEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // if (e.code == 'user-not-found') {
      //   throw ('No user found for that email.');
      // } else if (e.code == 'wrong-password') {
      //   throw ('Wrong password provided for that user.');
      // }
      throw (e.code);
    }
    return true;
  }

  static Future logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (Platform.isAndroid) {
      } else {
        await _googleSignInForIos.signOut();
      }
    } catch (e) {
      return;
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
