import 'package:solo_social/library.dart';

class GoogleAuth {
  /// Firebase related initializations
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign in with Google Auth
  Future<User> handleSignIn() async {
    final googleUser = await GoogleSignIn().signIn();

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    _auth.currentUser.updateProfile(
      displayName: googleUser.displayName,
      photoURL: googleUser.photoUrl,
    );
    return _auth.currentUser;
  }
}
