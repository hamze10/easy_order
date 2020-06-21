import 'package:easy_order/src/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 500.0,
      buttonColor: Colors.red[600],
      child: RaisedButton(
        onPressed: () {
          BlocProvider.of<LoginBloc>(context).add(
            LoginWithGooglePressed(),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Google',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ),
        colorBrightness: Brightness.light,
        elevation: 15.0,
      ),
    );
  }
}
