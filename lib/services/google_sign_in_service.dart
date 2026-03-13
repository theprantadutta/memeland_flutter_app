import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class GoogleSignInService {
  static final GoogleSignInService _instance = GoogleSignInService._internal();
  factory GoogleSignInService() => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  GoogleSignInService._internal();

  User? get currentUser => _auth.currentUser;
  bool get isSignedIn => currentUser != null;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (_googleSignIn.supportsAuthenticate()) {
        final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
        final GoogleSignInAuthentication googleAuth = googleUser.authentication;

        if (googleAuth.idToken == null) {
          throw Exception('Failed to get Google ID token');
        }

        final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);
        final UserCredential result = await _auth.signInWithCredential(credential);
        return result;
      } else {
        debugPrint('Google Sign-In authenticate not supported on this platform');
        return null;
      }
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      rethrow;
    }
  }

  Future<String?> getFirebaseIdToken() async {
    try {
      final user = currentUser;
      if (user == null) return null;
      return await user.getIdToken();
    } catch (e) {
      debugPrint('Error getting Firebase ID token: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    }
  }

  Future<void> disconnect() async {
    try {
      await _googleSignIn.disconnect();
      await _auth.signOut();
    } catch (e) {
      debugPrint('Error disconnecting: $e');
    }
  }
}
