import 'package:flutter/cupertino.dart';
import 'package:solo_social/firebase/firebase.dart';
import 'package:solo_social/library.dart';

class AuthCheck extends StatelessWidget with FirebaseMixin {
  @override
  Widget build(BuildContext context) {
    if (currentUser != null) {
      return PostFeed();
    } else {
      return Login();
    }
  }
}
