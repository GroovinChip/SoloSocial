import 'package:solo_social/library.dart';

class ComposeFab extends StatelessWidget {
  const ComposeFab({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      icon: Icon(Icons.edit),
      label: Text('Compose'),
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return ComposePost();
          },
          fullscreenDialog: true,
        ),
      ),
    );
  }
}
