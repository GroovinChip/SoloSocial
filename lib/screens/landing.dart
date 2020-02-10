import 'package:flutter/material.dart';
import 'package:solo_social/library.dart';

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'SoloSocial',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            //Placeholder(), //todo: replace with image
            //SizedBox(height: 16),
            Expanded(child: Container()),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: RaisedButton(
                      color: Theme.of(context).accentColor,
                      child: Text('Sign In'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: RaisedButton.icon(
                      icon: Icon(MdiIcons.google),
                      color: Theme.of(context).accentColor,
                      label: Text('Sign In with Google'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Don\'t want to use your Google account?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: OutlineButton(
                      child: Text('Sign Up with Email'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      borderSide: BorderSide(
                        color: Colors.grey[300],
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
