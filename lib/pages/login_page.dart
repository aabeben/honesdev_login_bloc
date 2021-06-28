import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honesdev_login_bloc/blocs/authentication/authentication.dart';
import 'package:honesdev_login_bloc/blocs/login/login.dart';
import 'package:honesdev_login_bloc/services/services.dart';

class LoginPage extends StatelessWidget {
  final String title;
  const LoginPage({Key? key, required String title})
      : title = title,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Area'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            final authBloc = BlocProvider.of<AuthenticationBloc>(context);
            if (state is AuthenticationNotAuthenticated) {
              return _AuthForm();
            }

            if (state is AuthenticationFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(state.message),
                    ElevatedButton(
                        onPressed: () => authBloc.add(AppLoaded()),
                        child: Text('Retry')),
                  ],
                ),
              );
            }

            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    final authService = RepositoryProvider.of<AuthenticationService>(context);

    return Container(
      alignment: Alignment.center,
      child: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(
          authenticationService: authService,
          authenticationBloc: authBloc,
        ),
        child: _SignInForm(),
      ),
    );
  }
}

class _SignInForm extends StatefulWidget {
  @override
  __SignInFormState createState() => __SignInFormState();
}

class __SignInFormState extends State<_SignInForm> {
  final signInFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool autovalidate = false;
  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    onButtonLoginPressed() {
      if (signInFormKey.currentState!.validate()) {
        loginBloc.add(LoginWithEmailButtonPressed(
            email: emailController.text, password: passwordController.text));
      } else {
        setState(() {
          autovalidate = true;
        });
      }
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          showError(state.error);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
            key: signInFormKey,
            autovalidateMode: autovalidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      filled: true,
                      isDense: true,
                    ),
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      isDense: true,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                    controller: passwordController,
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  ElevatedButton(
                    onPressed:
                        state is LoginLoading ? () {} : onButtonLoginPressed,
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          backgroundColor: Theme.of(context).primaryColor),
                    ),
                    child: Text('Log In'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Theme.of(context).errorColor,
      ),
    );
  }
}
