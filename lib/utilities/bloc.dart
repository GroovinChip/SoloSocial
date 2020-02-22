import 'package:solo_social/library.dart';

class Bloc {
  /// Controllers
  final _userController = BehaviorSubject<FirebaseUser>();

  /// Inputs
  Sink<FirebaseUser> get user => _userController.sink;

  /// Outputs
  ValueStream<FirebaseUser> get currentUser => _userController.stream;

  // Close controllers
  void close() {
    _userController.close();
  }
}