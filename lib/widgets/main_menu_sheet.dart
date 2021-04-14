import 'package:sentry/sentry.dart';
import 'package:solo_social/firebase/firebase.dart';
import 'package:solo_social/library.dart';
import 'package:solo_social/widgets/delete_all_posts_dialog.dart';

class MainMenuSheet extends StatefulWidget {
  @override
  _MainMenuSheetState createState() => _MainMenuSheetState();
}

class _MainMenuSheetState extends State<MainMenuSheet> with FirebaseMixin {
  PackageInfo? _packageInfo;
  PermissionStatus? storagePermission;

  @override
  void initState() {
    super.initState();
    _getPackageInfo();
    checkStoragePermission();
  }

  /// Retrieve information about this app for display
  Future<void> _getPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  Future<void> checkStoragePermission() async {
    await Permission.storage.status.then((value) {
      setState(() => storagePermission = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.posts(currentUser!.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final _posts = snapshot.data!.docs;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: ModalDrawerHandle(),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(currentUser!.photoURL!),
                ),
                title: Text(currentUser!.displayName!),
                subtitle: Text(currentUser!.email!),
                trailing: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Colors.white,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    auth.signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ),
              if (_posts.isNotEmpty) ...[
                ListTile(
                  leading: Icon(MdiIcons.cloudDownloadOutline),
                  title: Text('Download Posts'),
                  onTap: () async {
                    checkStoragePermission();
                    if (storagePermission!.isGranted) {
                      ExportUtility.instance
                          .postsToCsv(snapshot.data!)
                          .catchError((error) async {
                        await Sentry.captureException(error);
                      });
                      Navigator.pop(context);
                      ExportUtility.instance.shareFile();
                    } else {
                      await Permission.storage.request();
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete_outline),
                  title: Text('Delete All Posts'),
                  onTap: () async {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (_) => DeleteAllPostsDialog(
                        posts: _posts,
                      ),
                    );
                  },
                ),
              ],
              ListTile(
                leading: Icon(MdiIcons.sendOutline),
                title: Text('Send Feedback'),
                onTap: () {
                  Navigator.pop(context);
                  Wiredash.of(context)!.show();
                },
              ),
              Divider(height: 0),
              ListTile(
                leading: Icon(MdiIcons.informationVariant),
                title: Text('${_packageInfo!.appName}'),
                subtitle: Text('Version ${_packageInfo!.version}'),
              ),
            ],
          );
        }
      },
    );
  }
}
