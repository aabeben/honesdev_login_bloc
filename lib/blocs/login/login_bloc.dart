import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honesdev_login_bloc/blocs/authentication/authentication_bloc.dart';
import 'package:honesdev_login_bloc/blocs/authentication/authentication_event.dart';
import 'package:honesdev_login_bloc/blocs/login/login_event.dart';
import 'package:honesdev_login_bloc/blocs/login/login_state.dart';
import 'package:honesdev_login_bloc/exception/exception.dart';
import 'package:honesdev_login_bloc/services/services.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc _authenticationBloc;
  final AuthenticationService _authenticationService;
  LoginBloc(
      {required AuthenticationBloc authenticationBloc,
      required AuthenticationService authenticationService})
      : _authenticationBloc = authenticationBloc,
        _authenticationService = authenticationService,
        super(LoginInitial());
  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginWithEmailButtonPressed) {
      yield* _mapLoginWithEmailButtonPressedToState(event);
    }
  }

  Stream<LoginState> _mapLoginWithEmailButtonPressedToState(
      LoginWithEmailButtonPressed event) async* {
    yield LoginLoading();

    try {
      final user = await _authenticationService.loginWithEmailAndPassword(
          event.email, event.password);
      if (user != null) {
        _authenticationBloc.add(UserLoggedIn(user: user));
        yield LoginSuccess();
        yield LoginInitial();
      } else {
        yield LoginFailure(error: 'Something wierd happened!');
      }
    } on AuthenticationException catch (e) {
      yield LoginFailure(error: e.message);
    } catch (e) {
      yield LoginFailure(error: e.toString());
    }
  }
}
