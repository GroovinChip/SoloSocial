import 'package:sentry/sentry.dart';
import 'package:solo_social/firebase/firebase.dart';
import 'package:solo_social/library.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with FirebaseMixin {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).canvasColor,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Theme.of(context).canvasColor,
        systemNavigationBarIconBrightness: Brightness.light,
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
                  auth.signInWithGoogle().then((_) async {
                    if (currentUser != null) {
                      firestore.initStorageForUser(currentUser!.uid);
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => PostFeed(),
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
