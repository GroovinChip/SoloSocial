import 'package:solo_social/library.dart';

extension FirestoreX on FirebaseFirestore {
  CollectionReference users() => collection('Users');
  CollectionReference posts(String uid) => users().doc(uid).collection('Posts');

  Future<void> deletePost(String uid, String postId) async {
    await posts(uid).doc(postId).delete();
  }

  Future<void> deleteAllPosts(List<DocumentSnapshot> posts) async {
    for (final post in posts) {
      await post.reference.delete();
    }
  }
}
