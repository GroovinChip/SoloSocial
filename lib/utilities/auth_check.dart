import 'package:flutter/cupertino.dart';
import 'package:sentry/sentry.dart';
import 'package:solo_social/library.dart';

class AuthCheck extends StatefulWidget {
  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  FirebaseUser _user;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    final _userBloc = Provider.of<Bloc>(context);
    final _sentry = Provider.of<SentryClient>(context);

    /// Check for cached user
    void _checkForCachedUser() async {
      _user = await FirebaseAuth.instance.currentUser().catchError((error) async {
        await _sentry.captureException(exception: error);
      });
      if (_user != null) {
        _userBloc.user.add(_user);
      }
      setState(() {
        isLoading = false;
      });
    }

    _checkForCachedUser();
    return StreamBuilder<FirebaseUser>(
      stream: _userBloc.currentUser,
      builder: (context, snapshot) {
        if (!snapshot.hasData && isLoading == true) {
          return Container(color: Theme.of(context).canvasColor,);
        } else {
          if (_user != null) {
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
