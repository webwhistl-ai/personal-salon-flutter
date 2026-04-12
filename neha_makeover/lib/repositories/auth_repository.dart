import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> _initGoogleSignIn() async {
    await _googleSignIn.initialize();
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await _initGoogleSignIn();

      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate(scopeHint: ['email']);
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        // Since google_sign_in 7.x, the structure returned might only have idToken for certain flows.
        // Or access token is retrieved differently, but Firebase mostly uses idToken.
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        await _ensureUserInFirestore(userCredential.user!);
      }

      return userCredential;
    } catch (e) {
      print('Google Sign-In Error: \$e');
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
      print('Anonymous Sign-In Error: \$e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _initGoogleSignIn();
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
