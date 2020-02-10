import 'package:solo_social/library.dart';

class PostSearch extends SearchDelegate {

  @override
  // TODO: implement searchFieldLabel
  String get searchFieldLabel => 'Search Posts';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.indigo[600],

    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return null;
  }

  @override
  Widget buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return Scaffold();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Scaffold();
  }
}
