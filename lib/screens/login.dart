import 'package:sentry/sentry.dart';
import 'package:solo_social/library.dart';
import 'package:solo_social/utilities/firestore_control.dart';
import 'package:solo_social/utilities/google_auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GoogleAuth _googleAuth = GoogleAuth();

  @override
  Widget build(BuildContext context) {
    final _userBloc = Provider.of<Bloc>(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).canvasColor,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Theme.of(context).canvasColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'SoloSocial',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            Semantics(
              label: 'Sign in with Google',
              child: SignInButton(
                Buttons.GoogleDark,
                onPressed: () async {
                  _googleAuth.handleSignIn().then((_) async {
                    if (FirebaseAuth.instance.currentUser != null) {
                      _userBloc.user.add(FirebaseAuth.instance.currentUser);
                      final _firestoreControl = FirestoreControl(
                        userId: FirebaseAuth.instance.currentUser!.uid,
                        context: context,
                      );
                      _firestoreControl.getPosts();
                      if (_firestoreControl.posts!
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .path
                          .isEmpty) {
                        await _firestoreControl.posts!
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .set({});
                      }
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => PostFeed(
                            user: FirebaseAuth.instance.currentUser,
                          ),
                        ),
                        (route) => false,
                      );
                    }
                  }).catchError((exc) async {
                    print('GoogleAuth error: $exc');
                    await Sentry.captureException(exc);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
