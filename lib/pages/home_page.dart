import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honesdev_login_bloc/blocs/authentication/authentication.dart';
import 'package:honesdev_login_bloc/models/models.dart';

class HomePage extends StatelessWidget {
  final User user;
  const HomePage(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            Text(
              'Welcome ${user.name}',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
              )),
              child: Text('Log Out'),
              onPressed: () => authBloc.add(
                UserLoggedOut(),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
