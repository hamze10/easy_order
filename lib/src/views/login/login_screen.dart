import 'package:easy_order/src/blocs/blocs.dart';
import 'package:easy_order/src/repositories/user_repository.dart';
import 'package:easy_order/src/views/login/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

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
            WaveWidget(
              config: CustomConfig(
                gradients: [
                  [
                    Colors.teal[800],
                    Colors.teal[600],
                    Colors.teal[400],
                  ],
                  [
                    Colors.teal[800],
                    Colors.teal[600],
                    Colors.teal[300],
                  ],
                  [
                    Colors.teal[800],
                    Colors.teal[600],
                    Colors.teal[200],
                  ],
                ],
                durations: [19440, 10800, 6000],
                heightPercentages: [0.03, 0.01, 0.02],
                gradientBegin: Alignment.bottomCenter,
                gradientEnd: Alignment.topCenter,
              ),
              size: Size(double.infinity, double.infinity),
              waveAmplitude: 25,
              backgroundColor: Colors.teal[50],
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
