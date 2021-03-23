import 'package:sentry/sentry.dart';
import 'package:solo_social/library.dart';
import 'package:solo_social/utilities/firestore_control.dart';
import 'package:solo_social/widgets/delete_all_posts_dialog.dart';

class MainMenuSheet extends StatefulWidget {
  final User user;
  final GlobalKey<ScaffoldState> scaffoldKey;

  MainMenuSheet({
    @required this.user,
    this.scaffoldKey,
  });

  @override
  _MainMenuSheetState createState() => _MainMenuSheetState();
}

class _MainMenuSheetState extends State<MainMenuSheet> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  PermissionStatus storagePermission;
  List<StorageInfo> _storageInfo = [];

  Future<void> _getStorageInfo() async {
    List<StorageInfo> storageInfo;
    try {
      storageInfo = await PathProviderEx.getStorageInfo();
    } on PlatformException {}

    if (!mounted) return;

    setState(() {
      _storageInfo = storageInfo;
    });
  }

  void checkStoragePermission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions(
      [PermissionGroup.storage],
    );
    storagePermission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
  }

  @override
  void initState() {
    _getStorageInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _packageInfo = Provider.of<PackageInfo>(context);
    final _firestoreControl = FirestoreControl(
      userId: widget.user.uid,
      context: context,
    );
    _firestoreControl.getPosts();
    final ExportPosts _exportPosts = ExportPosts(_storageInfo);
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreControl.posts.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final _posts = snapshot.data.docs;
          return Theme(
            data: ThemeData.dark(),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ModalDrawerHandle(
                        /*handleWidth: 50,
                handleHeight: 2,*/
                        ),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(widget.user.photoURL),
                    ),
                    title: Text(widget.user.displayName),
                    subtitle: Text(widget.user.email),
                    trailing: OutlineButton(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: Text('Sign Out'),
                      onPressed: () {
                        _auth.signOut();
                        SystemChrome.setSystemUIOverlayStyle(
                            SystemUiOverlayStyle(
                          statusBarColor: Theme.of(context).canvasColor,
                          statusBarBrightness: Brightness.light,
                          systemNavigationBarColor:
                              Theme.of(context).canvasColor,
                          systemNavigationBarIconBrightness: Brightness.light,
                        ));
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ),
                  _posts.length > 0
                      ? ListTile(
                          leading: Icon(MdiIcons.cloudDownloadOutline),
                          title: Text('Download Posts'),
                          onTap: () {
                            checkStoragePermission();
                            if (storagePermission != null &&
                                storagePermission.value == 2) {
                              _exportPosts
                                  .postsToCsv(snapshot.data)
                                  .catchError((error) async {
                                await Sentry.captureException(error);
                              });
                              Navigator.pop(context);
                              _exportPosts.shareFile();
                            } else {
                              // snackbar?
                            }
                          },
                        )
                      : Container(),
                  _posts.length > 0
                      ? ListTile(
                          leading: Icon(Icons.delete_outline),
                          title: Text('Delete All Posts'),
                          onTap: () async {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (_) => DeleteAllPostsDialog(
                                firestoreControl: _firestoreControl,
                                posts: _posts,
                              ),
                            );
                          },
                        )
                      : Container(),
                  ListTile(
                    leading: Icon(MdiIcons.sendOutline),
                    title: Text('Send Feedback'),
                    onTap: () {
                      Navigator.pop(context);
                      Wiredash.of(context).show();
                    },
                  ),
                  Divider(height: 0),
                  ListTile(
                    leading: Icon(MdiIcons.informationVariant),
                    title: Text('${_packageInfo.appName}'),
                    subtitle: Text('Version ${_packageInfo.version}'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
