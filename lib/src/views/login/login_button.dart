import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback _onPressed;

  LoginButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 500.0,
      buttonColor: Colors.white,
      child: RaisedButton(
        onPressed: _onPressed,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Connexion',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
              letterSpacing: 1.2,
            ),
          ),
        ),
        colorBrightness: Brightness.light,
        elevation: 15.0,
      ),
    );
  }
}
