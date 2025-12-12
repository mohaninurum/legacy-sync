import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Login with Apple and Firebase
  Future<void> signInWithApple({
    required Function(String userId) onSuccess,
    required Function(String error) onFailure,
  }) async {
    try {
      // Request Apple ID credential
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create OAuth credential for Firebase
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Firebase sign in
      final UserCredential userCredential = await _auth.signInWithCredential(
        oauthCredential,
      );
      final User? user = userCredential.user;

      if (user != null) {
        // Return only the user ID
        onSuccess(user.uid);
      } else {
        onFailure("User data not found");
      }
    } catch (e) {
      // Handle specific Apple Sign In errors
      if (e is SignInWithAppleAuthorizationException) {
        switch (e.code) {
          case AuthorizationErrorCode.canceled:
            onFailure("Apple Sign In was cancelled by user");
            break;
          case AuthorizationErrorCode.failed:
            onFailure("Apple Sign In failed");
            break;
          case AuthorizationErrorCode.invalidResponse:
            onFailure("Invalid response from Apple");
            break;
          case AuthorizationErrorCode.notHandled:
            onFailure("Apple Sign In not handled");
            break;
          case AuthorizationErrorCode.notInteractive:
            onFailure("Apple Sign In not interactive");
            break;
          case AuthorizationErrorCode.unknown:
            onFailure("Unknown Apple Sign In error");
            break;
        }
      } else {
        onFailure("Apple Sign In failed: ${e.toString()}");
      }
    }
  }

  /// Check if Apple Sign In is available on this device
  static Future<bool> isAppleSignInAvailable() async {
    return await SignInWithApple.isAvailable();
  }

  /// Sign out from Apple (clears Firebase session)
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Check if user is already logged in
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
