import 'package:solo_social/firebase/firebase.dart';
import 'package:solo_social/library.dart';

class PostFeed extends StatefulWidget {
  @override
  _PostFeedState createState() => _PostFeedState();
}

class _PostFeedState extends State<PostFeed> with FirebaseMixin {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).canvasColor,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Theme.of(context).canvasColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Posts',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: firestore
              .posts(currentUser!.uid)
              .orderBy('TimeCreated', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final _posts = snapshot.data!.docs;
              if (_posts.isEmpty) {
                return Center(
                  child: Text('No Posts'),
                );
              } else {
                return ListView.builder(
                  itemCount: _posts.length,
                  padding: EdgeInsets.only(right: 8, left: 8),
                  itemBuilder: (context, index) {
                    final _post = _posts[index];
                    var _tags;
                    if (_post['Tags'] != null) {
                      _tags =
                          (jsonDecode(_post['Tags']) as List).cast<String>();
                    }
                    return PostCard(
                      timeCreated: (_post['TimeCreated'] as Timestamp).toDate(),
                      postId: _post.id,
                      postText: _post['PostText'],
                      tags: _tags == null || _tags.length == 0 ? [] : _tags,
                      sourceLink: _post['SourceLink'].toString().isEmpty
                          ? 'NoSource'
                          : _post['SourceLink'],
                    );
                  },
                );
              }
            }
          },
        ),
        floatingActionButton: ComposeFab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Semantics(
                  label: 'Open Menu',
                  child: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          topLeft: Radius.circular(12),
                        ),
                      ),
                      builder: (_) => MainMenuSheet(),
                    ),
                  ),
                ),
                /*IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => showSearch(
                    context: context,
                    delegate: PostSearch(),
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
