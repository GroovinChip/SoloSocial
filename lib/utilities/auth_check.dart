import 'package:flutter/cupertino.dart';
import 'package:solo_social/library.dart';

@deprecated
class AuthCheck extends StatefulWidget {
  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  User? _user;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    final _userBloc = Provider.of<Bloc>(context);

    /// Check for cached user
    void _checkForCachedUser() async {
      _user = FirebaseAuth.instance.currentUser;
      if (_user != null) {
        _userBloc.user.add(_user);
      }
      setState(() {
        isLoading = false;
      });
    }

    _checkForCachedUser();
    return StreamBuilder<User?>(
      stream: _userBloc.currentUser,
      builder: (context, snapshot) {
        if (!snapshot.hasData && isLoading) {
          return Container(
            color: Theme.of(context).canvasColor,
          );
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
