import 'package:solo_social/library.dart';

extension FirebaseAuthX on FirebaseAuth {
  /// Sign in with Google.
  ///
  /// This handles the displaying of the Google SignIn dialog and
  /// finalizing with Firebase Auth.
  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final googleAuth = await googleUser!.authentication;

    final googleAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await signInWithCredential(googleAuthCredential);

    currentUser!.updateProfile(
      displayName: googleUser.displayName,
      photoURL: googleUser.photoUrl,
    );
  }

  /// Sign in with Apple.
  ///
  /// This handles the displaying of the Sign in with Apple dialog and
  /// finalizing with Firebase Auth.
  Future<User> signInWithApple() async {
    throw UnimplementedError('use sign_in_with_apple package');
  }
}
