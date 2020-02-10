import 'package:solo_social/library.dart';

class Bloc {
  /// Controllers
  final _userController = BehaviorSubject<FirebaseUser>();
  final _firstLaunchController = BehaviorSubject<bool>();

  /// Inputs
  Sink<FirebaseUser> get user => _userController.sink;
  Sink<bool> get firstLaunchValue => _firstLaunchController.sink;

  /// Outputs
  ValueStream<FirebaseUser> get currentUser => _userController.stream;
  ValueStream<bool> get isFirstLaunch => _firstLaunchController.stream;

  // Close controllers
  void close() {
    _userController.close();
    _firstLaunchController.close();
  }
}