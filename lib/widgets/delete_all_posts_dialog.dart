import 'package:solo_social/library.dart';

class DeleteAllPostsDialog extends StatelessWidget {
  const DeleteAllPostsDialog({
    Key? key,
    required FirestoreControl firestoreControl,
    required List<DocumentSnapshot> posts,
  })   : _firestoreControl = firestoreControl,
        _posts = posts,
        super(key: key);

  final FirestoreControl _firestoreControl;
  final List<DocumentSnapshot> _posts;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text('Are you sure you want to delete all your posts?'),
      actions: [
        TextButton(
          child: Text(
            'YES',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () async {
            await _firestoreControl.deleteAllPosts(_posts);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
