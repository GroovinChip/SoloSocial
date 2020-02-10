import 'package:solo_social/library.dart';

class GoogleAuth {
  /// Firebase related initializations
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign in with Google Auth
  Future<FirebaseUser> handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    UserUpdateInfo _userUpdateInfo = UserUpdateInfo();
    _userUpdateInfo.photoUrl = googleUser.photoUrl;
    _userUpdateInfo.displayName = googleUser.displayName;
    user.updateProfile(_userUpdateInfo);
    return user;
  }
}