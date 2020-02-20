import 'package:flutter/cupertino.dart';
import 'package:sentry/sentry.dart';
import 'package:solo_social/library.dart';

class AuthCheck extends StatefulWidget {
  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  SharedPreferences _prefs;
  bool _isFirstLaunch;
  FirebaseUser _user;

  void wait() async {
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    final _userBloc = Provider.of<Bloc>(context);
    final _sentry = Provider.of<SentryClient>(context);
    /// Check for first launch; is true by default
    void _checkForFirstLaunch() async {
      try {
        _prefs = await SharedPreferences.getInstance();
        _isFirstLaunch = _prefs.getBool('isFirstLaunch') ?? true;
        _userBloc.firstLaunchValue.add(_isFirstLaunch);
      } catch (e) {
        print(e);
      }
    }

    /// Check for cached user
    void _checkForCachedUser() async {
      _user = await FirebaseAuth.instance.currentUser().catchError((error) async {
        await _sentry.captureException(exception: error);
      });
    }

    _checkForFirstLaunch();
    _checkForCachedUser();
    return StreamBuilder<bool>(
      stream: _userBloc.isFirstLaunch,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          wait();
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'SoloSocial',
                    style: GoogleFonts.openSans(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
            ),
          );
        } else {
          final _firstLaunch = snapshot.data;
          if (_firstLaunch == false && _user != null) {
            _userBloc.user.add(_user);
            return PostFeed(
              user: _user,
            );
          } else {
            return Login();
          }
        }
      },
    );
  }
}
