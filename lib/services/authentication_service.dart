import 'dart:async';
import 'package:honesdev_login_bloc/exception/exception.dart';
import 'package:honesdev_login_bloc/models/models.dart';

abstract class AuthenticationService {
  Future<User>? getCurrentUser();

  Future<User>? loginWithEmailAndPassword(String email, String password);

  Future<void>? logOut();
}

class FakeAuthenticationService extends AuthenticationService {
  @override
  Future<User>? getCurrentUser() {
    return null;
  }

  @override
  Future<void>? logOut() {
    return null;
  }

  @override
  Future<User> loginWithEmailAndPassword(String email, String password) async {
    await Future.delayed(Duration(milliseconds: 500));
    if (email.toLowerCase() != 'bhasanudin@gmail.com' ||
        password != '44b3b3n') {
      throw AuthenticationException(message: 'Invalid email or password!');
    }
    return User(name: 'Beny Hasanudin', email: email);
  }
}
