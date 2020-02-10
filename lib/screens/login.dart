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
    final _sentry = Provider.of<SentryClient>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SignInButton(
              Buttons.Google,
              onPressed: () async {
                _googleAuth.handleSignIn().then((FirebaseUser user) async {
                  _userBloc.user.add(user);
                  final _firestoreControl = FirestoreControl(
                    userId: user.uid,
                    context: context,
                  );
                  _firestoreControl.getPosts();
                  if (_firestoreControl.posts.document(user.uid).path.isEmpty) {
                    await _firestoreControl.posts.document(user.uid).setData({});
                  }
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => PostFeed(
                        user: user,
                      ),
                    ),
                        (route) => false,
                  );
                }).catchError((exc) async {
                  print('GoogleAuth error: $exc');
                  await _sentry.captureException(exception: exc);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
