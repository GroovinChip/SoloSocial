import 'package:solo_social/library.dart';

class FirestoreControl {
  final CollectionReference users = FirebaseFirestore.instance.collection('Users');
  final String userId;
  final BuildContext context;
  CollectionReference posts;

  FirestoreControl({
    this.userId,
    this.context,
  });

  /// Populate posts collection with post documents
  void getPosts() {
    posts = users.doc(userId).collection('Posts');
  }

  /// Delete all post documents from posts collection
  Future deleteAllPosts(List<DocumentSnapshot> postsToDelete) async {
    for (int i = 0; i < postsToDelete.length; i++) {
      DocumentReference _postRef = postsToDelete[i].reference;
      _postRef.delete();
    }
  }
}
