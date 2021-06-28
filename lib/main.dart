import 'package:flutter/material.dart';
import 'package:honesdev_login_bloc/pages/pages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honesdev_login_bloc/services/services.dart';

import 'blocs/authentication/authentication.dart';

void main() {
  runApp(
    RepositoryProvider<AuthenticationService>(
      create: (context) => FakeAuthenticationService(),
      child: BlocProvider<AuthenticationBloc>(
        create: (context) {
          final authenticationService =
              RepositoryProvider.of<AuthenticationService>(context);
          return AuthenticationBloc(
              authenticationService: authenticationService)
            ..add(AppLoaded());
        },
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Authentication Bloc',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            return HomePage(state.user);
          }
          return LoginPage(
            title: 'Please Login',
          );
        },
      ),
    );
  }
}
