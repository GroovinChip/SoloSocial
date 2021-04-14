import 'package:solo_social/firebase/firebase.dart';
import 'package:solo_social/library.dart';

class DeleteAllPostsDialog extends StatelessWidget with FirebaseMixin {
  const DeleteAllPostsDialog({
    Key? key,
    required List<DocumentSnapshot> posts,
  })   : _posts = posts,
        super(key: key);

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
            await firestore.deleteAllPosts(_posts);
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
