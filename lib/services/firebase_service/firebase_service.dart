import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Google Sign In setup
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  /// Check if user is already logged in
  User? getCurrentUser() => _auth.currentUser;

  /// Login with Google and always show account picker
  Future<void> signInWithGoogle({
    required Function(Map<String, dynamic> userData) onSuccess,
    required Function(String error) onFailure,
  }) async {
    try {
      // Force sign out to ensure account picker is shown
      await _googleSignIn.signOut();
      await _auth.signOut();

      // Trigger Google Sign-In
      final GoogleSignInAccount? googleUser =
      await _googleSignIn.signIn();

      if (googleUser == null) {
        onFailure("Login cancelled by user");
        return;
      }

      // Get Google authentication details
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Create Firebase credential
      final OAuthCredential credential =
      GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase sign in
      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user == null) {
        onFailure("User data not found");
        return;
      }

      final userData = {
        "uid": user.uid,
        "name": user.displayName ?? "",
        "email": user.email ?? "",
        "photoUrl": user.photoURL ?? "",
        "phone": user.phoneNumber ?? "",
      };

      onSuccess(userData);

    } catch (e) {
      onFailure("Sign-in failed: ${e.toString()}");
    }
  }
}
