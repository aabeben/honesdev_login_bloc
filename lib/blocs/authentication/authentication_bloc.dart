import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honesdev_login_bloc/services/services.dart';

import 'authentication.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationService _authenticationService;
  AuthenticationBloc({required AuthenticationService authenticationService})
      : _authenticationService = authenticationService,
        super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(event) async* {
    if (event is AppLoaded) {
      yield* _mapAppLoadedToState(event);
    }

    if (event is UserLoggedIn) {
      yield* _mapUserLoggedInToState(event);
    }

    if (event is UserLoggedOut) {
      yield* _mapUserLoggedOutToState(event);
    }
  }

  Stream<AuthenticationState> _mapAppLoadedToState(AppLoaded event) async* {
    yield AuthenticationLoading();

    try {
      await Future.delayed(Duration(
        milliseconds: 500,
      )); // simulated delay
      final currentUser = await _authenticationService.getCurrentUser();

      if (currentUser != null) {
        yield AuthenticationAuthenticated(user: currentUser);
      } else {
        yield AuthenticationNotAuthenticated();
      }
    } catch (e) {
      yield AuthenticationFailure(message: e.toString());
    }
  }

  Stream<AuthenticationState> _mapUserLoggedInToState(
      UserLoggedIn event) async* {
    yield AuthenticationAuthenticated(user: event.user);
  }

  Stream<AuthenticationState> _mapUserLoggedOutToState(
      UserLoggedOut event) async* {
    await _authenticationService.logOut();
    yield AuthenticationNotAuthenticated();
  }
}
