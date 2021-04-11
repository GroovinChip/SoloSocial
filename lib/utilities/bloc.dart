import 'package:solo_social/library.dart';

class Bloc {
  /// Controllers
  final _userController = BehaviorSubject<User?>();

  /// Inputs
  Sink<User?> get user => _userController.sink;

  /// Outputs
  ValueStream<User?> get currentUser => _userController.stream;

  // Close controllers
  void close() {
    _userController.close();
  }
}