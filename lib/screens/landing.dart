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
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text('Sign In'),
                      onPressed: null,
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
                    child: ElevatedButton.icon(
                      icon: Icon(MdiIcons.google),
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      label: Text('Sign In with Google'),
                      onPressed: null,
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
                    child: OutlinedButton(
                      child: Text('Sign Up with Email'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.grey[400]!,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: null,
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
