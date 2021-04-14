import 'package:chips_choice/chips_choice.dart';
import 'package:solo_social/firebase/firebase.dart';
import 'package:solo_social/library.dart';
import 'package:validators/validators.dart';

class ComposePost extends StatefulWidget {
  @override
  _ComposePostState createState() => _ComposePostState();
}

class _ComposePostState extends State<ComposePost> with FirebaseMixin {
  TextEditingController _postTextController = TextEditingController();
  TextEditingController _sourceLinkController = TextEditingController();
  TextEditingController _addTagController = TextEditingController();
  List<String> _tags = [];
  List<String> _options = [
    'Post',
    'Comment',
    'Facebook',
    'Instagram',
    'Twitter',
    'Reddit',
    'Snapchat',
  ];
  final _sourceLinkFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).canvasColor,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Theme.of(context).canvasColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: KeyboardDismisser(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Compose',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: const Text(
                    'Post',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                  backgroundColor: Theme.of(context).accentColor,
                  onSelected: (value) {
                    _validatePost(
                      value,
                      _postTextController.text,
                      _sourceLinkController.text,
                    );
                  },
                  selected: false,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 134),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(currentUser!.photoURL!),
                          backgroundColor: Theme.of(context).accentColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _postTextController,
                          autofocus: true,
                          textCapitalization: TextCapitalization.sentences,
                          autocorrect: true,
                          decoration: InputDecoration(
                            hintText: 'What\'s on your mind?',
                          ),
                          maxLines: 5,
                          maxLength: 256,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 30),
                      const Text(
                        'Tags',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 3),
                      Expanded(
                        child: ChipsChoice<String>.multiple(
                          value: _tags,
                          choiceActiveStyle: C2ChoiceStyle(
                            color: Colors.white,
                          ),
                          choiceItems: C2Choice.listFrom<String, String>(
                            source: _options,
                            value: (i, v) => v,
                            label: (i, v) => v,
                          ),
                          onChanged: (val) => setState(() => _tags = val),
                          wrapped: true,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 18),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        label: Text(
                          'Add Tag',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        icon: Icon(
                          MdiIcons.tagPlusOutline,
                          color: Colors.grey.shade400,
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) => SimpleDialog(
                            title: const Text('New Tag'),
                            contentPadding: const EdgeInsets.all(16),
                            children: [
                              TextField(
                                controller: _addTagController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                autofocus: true,
                                decoration: InputDecoration(
                                  hintText: 'Tag Name',
                                  enabledBorder: Theme.of(context)
                                      .inputDecorationTheme
                                      .enabledBorder,
                                  focusedBorder: Theme.of(context)
                                      .inputDecorationTheme
                                      .enabledBorder,
                                  fillColor: Theme.of(context)
                                      .inputDecorationTheme
                                      .fillColor,
                                  filled: Theme.of(context)
                                      .inputDecorationTheme
                                      .filled,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ChoiceChip(
                                    label: const Text('Complete'),
                                    backgroundColor:
                                        Theme.of(context).accentColor,
                                    selected: false,
                                    onSelected: (value) {
                                      if (value &&
                                          _addTagController.text.isNotEmpty) {
                                        setState(() {
                                          _options.add(
                                            _addTagController.text,
                                          );
                                        });
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const SizedBox(width: 30),
                      Text(
                        'Other',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const SizedBox(width: 18),
                      OutlinedButton.icon(
                        icon: Icon(
                          Icons.link,
                          color: Colors.grey.shade400,
                        ),
                        label: Text(
                          'Refer to Source',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) => SimpleDialog(
                            title: Text('Source Reference'),
                            contentPadding: EdgeInsets.all(16),
                            children: [
                              Form(
                                key: _sourceLinkFormKey,
                                child: TextFormField(
                                  controller: _sourceLinkController,
                                  keyboardType: TextInputType.url,
                                  validator: (url) {
                                    if (isURL(url)) {
                                      return null;
                                    } else {
                                      return 'Not a valid URL';
                                    }
                                    //return validate.isURL(url) == true ? 'Not a valid URL' : '';
                                  },
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    hintText: 'Paste link here',
                                    enabledBorder: Theme.of(context)
                                        .inputDecorationTheme
                                        .enabledBorder,
                                    focusedBorder: Theme.of(context)
                                        .inputDecorationTheme
                                        .enabledBorder,
                                    fillColor: Theme.of(context)
                                        .inputDecorationTheme
                                        .fillColor,
                                    filled: Theme.of(context)
                                        .inputDecorationTheme
                                        .filled,
                                    errorBorder: Theme.of(context)
                                        .inputDecorationTheme
                                        .errorBorder,
                                    focusedErrorBorder: Theme.of(context)
                                        .inputDecorationTheme
                                        .focusedErrorBorder,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ChoiceChip(
                                    label: Text('Complete'),
                                    backgroundColor:
                                        Theme.of(context).accentColor,
                                    selected: false,
                                    onSelected: (value) {
                                      // add tag indicating valid source link
                                      // ensure tag only is entered once
                                      if (_sourceLinkFormKey.currentState!
                                          .validate()) {
                                        if (_sourceLinkController
                                                .text.isNotEmpty &&
                                            !_tags.contains('Source')) {
                                          setState(() {
                                            _options.add('Source');
                                            _tags.add('Source');
                                          });
                                        }
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (isURL(_sourceLinkController.text)) ...[
                    Row(
                      children: <Widget>[
                        SizedBox(width: 18),
                        Text(
                          '==> ' + _sourceLinkController.text,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Data validation prior to adding to Firestore
  void _validatePost(
    bool value,
    String postText,
    String sourceLink,
  ) {
    if (value) {
      if (postText.isNotEmpty) {
        DateTime _timeCreated = DateTime.now();
        String _sourceLink = isURL(sourceLink) ? sourceLink : '';
        firestore
            .addPost(
              currentUser!,
              postText,
              _timeCreated,
              _sourceLink,
              _tags,
            )
            .then((value) => Navigator.of(context).pop());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  MdiIcons.alertCircleOutline,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Text('Please add some text to your post'),
              ],
            ),
            backgroundColor: Theme.of(context).accentColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
