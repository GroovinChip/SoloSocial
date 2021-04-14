import 'package:solo_social/library.dart';

class ComposeFab extends StatelessWidget {
  const ComposeFab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Compose Post',
      child: FloatingActionButton.extended(
        icon: Icon(Icons.edit),
        label: Text('COMPOSE'),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ComposePost();
            },
            fullscreenDialog: true,
          ),
        ),
      ),
    );
  }
}
