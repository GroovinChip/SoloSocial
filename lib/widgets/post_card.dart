import 'package:solo_social/firebase/firebase.dart';
import 'package:solo_social/library.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatefulWidget {
  const PostCard({
    Key? key,
    required this.timeCreated,
    required this.postId,
    required this.postText,
    this.tags,
    this.sourceLink,
  }) : super(key: key);

  final DateTime timeCreated;
  final String postId;
  final String postText;
  final List<String>? tags;
  final String? sourceLink;

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> with FirebaseMixin {
  void _handleMenuSelection(String selection) {
    switch (selection) {
      case 'Share':
        Share.share(widget.postText,
            subject: 'Check out my post from SoloSocial');
        break;
      case 'Delete':
        firestore.deletePost(currentUser!.uid, widget.postId);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(currentUser!.photoURL!),
            ),
            title: Text(
              currentUser!.displayName!,
              style: TextStyle(
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
                child: Icon(Icons.keyboard_arrow_down),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(MdiIcons.share),
                        SizedBox(width: 8),
                        Text('Share'),
                      ],
                    ),
                    value: 'Share',
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(MdiIcons.delete),
                        SizedBox(width: 8),
                        Text('Delete'),
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
              style: TextStyle(fontSize: 18),
            ),
          ),
          if (widget.tags!.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Container(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.tags!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip(
                        label: Text(widget.tags![index]),
                        backgroundColor: Theme.of(context).accentColor,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (widget.sourceLink != 'NoSource') ...[
            LinkPreviewer(
              link: widget.sourceLink!,
              defaultPlaceholderColor: Colors.indigo.shade300,
              placeholder: Text('Loading link preview'),
              borderRadius: 14,
              backgroundColor: Colors.indigo.shade300,
              titleTextColor: Colors.white,
              bodyTextColor: Colors.white,
              bodyMaxLines: 2,
              borderColor: Colors.indigo.shade300,
            ),
          ],
        ],
      ),
    );
  }
}
