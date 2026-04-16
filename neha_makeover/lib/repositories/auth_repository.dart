import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    // Use the actual Web Client ID provided from Google Cloud Console for web OAuth credentials.
    clientId: kIsWeb ? '251823266093-l5bk15q3ckbmhi7k6ktoq3tjgge6j549.apps.googleusercontent.com' : null,
  );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser;

      if (kIsWeb) {
        // Attempt silent sign-in first to avoid popup blockers on web
        googleUser = await _googleSignIn.signInSilently();
      }

      // If silent sign in fails or we are not on web, do full signIn
      googleUser ??= await _googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        await _ensureUserInFirestore(userCredential.user!);
      }

      return userCredential;
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      rethrow;
    }
  }

  Future<UserCredential> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      if (userCredential.user != null) {
        await _ensureUserInFirestore(userCredential.user!, isGuest: true);
      }
      return userCredential;
    } catch (e) {
      debugPrint('Anonymous Sign-In Error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<void> _ensureUserInFirestore(User user, {bool isGuest = false}) async {
    final docRef = _firestore.collection('users').doc(user.uid);
    final docSnap = await docRef.get();

    if (!docSnap.exists) {
      final newUser = UserModel(
        id: user.uid,
        email: user.email ?? '',
        displayName: isGuest ? 'Guest User' : (user.displayName ?? 'New User'),
        photoUrl: user.photoURL ?? '',
        role: 'customer',
      );
      await docRef.set(newUser.toMap());
    }
  }

  Future<UserModel?> getUserProfile(String uid) async {
    final docSnap = await _firestore.collection('users').doc(uid).get();
    if (docSnap.exists) {
      return UserModel.fromMap(docSnap.data()!, docSnap.id);
    }
    return null;
  }
}
