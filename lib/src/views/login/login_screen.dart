import 'package:easy_order/src/blocs/blocs.dart';
import 'package:easy_order/src/repositories/user/user_repository.dart';
import 'package:easy_order/src/views/login/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  final UserRepository _userRepository;

  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(userRepository: _userRepository),
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.grey[100],
            ),
            LoginForm(
              userRepository: _userRepository,
            ),
          ],
        ),
      ),
    );
  }
}
