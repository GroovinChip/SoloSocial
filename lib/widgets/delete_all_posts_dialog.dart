import 'package:solo_social/library.dart';

class DeleteAllPostsDialog extends StatelessWidget {
  const DeleteAllPostsDialog({
    Key key,
    @required FirestoreControl firestoreControl,
    @required List<DocumentSnapshot> posts,
  })  : _firestoreControl = firestoreControl,
        _posts = posts,
        super(key: key);

  final FirestoreControl _firestoreControl;
  final List<DocumentSnapshot> _posts;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: AlertDialog(
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text('Delete All Posts?'),
        content: Text('Are you sure you want to delete all your posts?'),
        actions: <Widget>[
          TextButton(
            child: Text('Yes'),
            onPressed: () async {
              await _firestoreControl.deleteAllPosts(_posts);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
