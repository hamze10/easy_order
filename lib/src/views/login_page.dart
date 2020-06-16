import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Text customText({String content, double size}) => Text(
        content,
        style: TextStyle(
          color: Colors.white,
          fontSize: size,
        ),
      );

  TextFormField customTFF({IconData icon, String text, String validatorText}) =>
      TextFormField(
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          icon: Icon(
            icon,
            color: Colors.white,
          ),
          labelText: text,
          labelStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        validator: (value) => value.isEmpty ? validatorText : null,
        style: TextStyle(
          color: Colors.orange[200],
        ),
      );

  ButtonTheme customButton(
          {double size = 220,
          String content,
          Color color,
          double fontSize = 16.0,
          Color textColor = Colors.black}) =>
      ButtonTheme(
        minWidth: size,
        buttonColor: color,
        child: RaisedButton(
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              content,
              style: TextStyle(
                fontSize: fontSize,
                color: textColor,
              ),
            ),
          ),
          colorBrightness: Brightness.light,
          elevation: 15.0,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[400],
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/background2.png'),
              fit: BoxFit.cover,
            ),
          ),
          constraints: BoxConstraints.expand(),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Image.asset('images/logo.webp'),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        customTFF(
                          icon: Icons.email,
                          text: 'EMAIL',
                          validatorText: 'Veuillez entrer un email.',
                        ),
                        customTFF(
                          icon: Icons.lock,
                          text: 'MOT DE PASSE',
                          validatorText: 'Veuillez entrer un mot de passe.',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              customText(
                                  content: 'Mot de passe oublié ? ', size: 11),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: customButton(
                            color: Colors.white,
                            content: 'Connexion',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: customButton(
                            color: Colors.red[600],
                            content: 'Google',
                            textColor: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              customText(
                                content: 'Pas de compte ? ',
                                size: 12.0,
                              ),
                              Text(
                                'créer un nouveau compte.',
                                style: TextStyle(
                                  color: Colors.orange[200],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
