import 'package:solo_social/library.dart';

extension FirestoreX on FirebaseFirestore {
  CollectionReference users() => collection('Users');
  CollectionReference posts(String uid) => users().doc(uid).collection('Posts');

  void initStorageForUser(String uid) {
    if (users().doc(uid).path.isEmpty) {
      users().doc(uid).set({});
    }
  }

  Future<void> addPost(
    User user,
    String postText,
    DateTime _timeCreated,
    String sourceLink,
    List<String> tags,
  ) async {
    try {
      await posts(user.uid).add({
        'Username': user.displayName,
        'PostText': postText,
        'TimeCreated': Timestamp.fromDate(_timeCreated),
        'Tags': jsonEncode(tags),
        'SourceLink': sourceLink,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> deletePost(String uid, String postId) async {
    await posts(uid).doc(postId).delete();
  }

  Future<void> deleteAllPosts(List<DocumentSnapshot> posts) async {
    for (final post in posts) {
      await post.reference.delete();
    }
  }
}
