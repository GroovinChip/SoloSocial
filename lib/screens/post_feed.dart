import 'package:solo_social/library.dart';
import 'package:solo_social/utilities/firestore_control.dart';

class PostFeed extends StatefulWidget {
  final FirebaseUser user;

  const PostFeed({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  _PostFeedState createState() => _PostFeedState();
}

class _PostFeedState extends State<PostFeed> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final _firestoreControl = FirestoreControl(
      userId: widget.user.uid,
      context: context,
    );
    _firestoreControl.getPosts();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        title: Text(
          'Posts',
          style: GoogleFonts.openSans(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreControl.posts.orderBy('TimeCreated', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final _posts = snapshot.data.documents;
            if (_posts.length == 0 || _posts == null) {
              return Center(
                child: Text(
                  'No Posts',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: _posts.length,
                padding: EdgeInsets.only(right: 8, left: 8),
                itemBuilder: (context, index) {
                  final _post = _posts[index];
                  var _tags;
                  if (_post['Tags'] != null) {
                    _tags = (jsonDecode(_post['Tags']) as List).cast<String>();
                  }
                  return PostCard(
                    user: widget.user,
                    timeCreated: (_post['TimeCreated'] as Timestamp).toDate(),
                    postId: _post.documentID,
                    username: _post['Username'],
                    postText: _post['PostText'],
                    tags: _tags == null || _tags.length == 0 ? [] : _tags,
                    sourceLink: _post['SourceLink'].toString().isEmpty ? 'NoSource' : _post['SourceLink'],
                    firestoreControl: _firestoreControl,
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
            children: <Widget>[
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
                    backgroundColor: Theme.of(context).canvasColor,
                    builder: (_) => MainMenuSheet(
                      user: widget.user,
                      scaffoldKey: _scaffoldKey,
                    ),
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
    );
  }
}
