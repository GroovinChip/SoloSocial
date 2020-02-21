import 'package:solo_social/library.dart';
import 'package:solo_social/utilities/firestore_control.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatefulWidget {
  final FirebaseUser user;
  final DateTime timeCreated;
  final String postId;
  final String username;
  final String postText;
  final List<String> tags;
  final String sourceLink;
  final FirestoreControl firestoreControl;

  const PostCard({
    Key key,
    this.user,
    this.timeCreated,
    this.postId,
    this.username,
    this.postText,
    this.tags,
    this.sourceLink,
    this.firestoreControl,
  }) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  void _handleMenuSelection(String selection) {
    switch (selection) {
      case 'GoToSource':
        launch(widget.sourceLink);
        break;
      case 'Share':
        Share.share(widget.postText, subject: 'Check out my post from SoloSocial');
        break;
      case 'Delete':
        setState(() {
          widget.firestoreControl.posts.document(widget.postId).delete();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.indigo[300],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.user.photoUrl),
            ),
            title: Text(
              widget.username,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              timeago.format(widget.timeCreated),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: Semantics(
              label: 'See options',
              child: PopupMenuButton(
                child: Ink(
                  child: Icon(Icons.keyboard_arrow_down),
                  width: 50,
                  height: 50,
                ),
                color: Colors.indigo[700],
                itemBuilder: (_) => [
                  widget.sourceLink != 'NoSource' ? PopupMenuItem(
                    child: Row(
                      children: <Widget>[
                        Icon(MdiIcons.exitRun),
                        SizedBox(width: 8),
                        Text(
                          'Go to source',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ],
                    ),
                    value: 'GoToSource',
                  ) : null,
                  PopupMenuItem(
                    child: Row(
                      children: <Widget>[
                        Icon(MdiIcons.share),
                        SizedBox(width: 8),
                        Text(
                          'Share',
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),
                    value: 'Share',
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: <Widget>[
                        Icon(MdiIcons.delete),
                        SizedBox(width: 8),
                        Text(
                          'Delete',
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),
                    value: 'Delete',
                  ),
                ],
                onSelected: _handleMenuSelection,
              ),
            ),
          ),
          ListTile(
            title: Text(
              widget.postText,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          widget.tags.length > 0 ? Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.tags.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Chip(
                      label: Text(widget.tags[index]),
                      backgroundColor: Theme.of(context).accentColor,
                    ),
                  );
                },
              ),
            ),
          ) : Container(),
          widget.tags.length > 0 ? SizedBox(height: 12) : Container(),
        ],
      ),
    );
  }
}
