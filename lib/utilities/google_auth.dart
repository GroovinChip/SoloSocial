import 'package:solo_social/library.dart';

@deprecated
class GoogleAuth {
  /// Firebase related initializations
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign in with Google Auth
  Future<void> handleSignIn() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final googleAuth = await googleUser!.authentication;

    final googleAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(googleAuthCredential);

    _auth.currentUser!.updateProfile(
      displayName: googleUser.displayName,
      photoURL: googleUser.photoUrl,
    );
  }
}
