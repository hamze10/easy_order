import 'package:flutter/material.dart';
import 'package:easy_order/src/models/login.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _user = Login();

  Text customText({String content, double size}) => Text(
        content,
        style: TextStyle(
          color: Colors.white,
          fontSize: size,
        ),
      );

  TextFormField customTFF(
          {IconData icon,
          String text,
          String validatorText,
          bool isEmail = false}) =>
      TextFormField(
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          labelText: text,
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          errorStyle: TextStyle(
            color: Colors.red[300],
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red[300],
            ),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red[300],
            ),
          ),
          suffixIcon: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        validator: (value) {
          if (value.isEmpty) return validatorText;
          if (isEmail) {
            if (!RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value))
              return 'Veuillez entrer une adresse email valide';
          } else {
            if (value.length < 8)
              return 'Votre mot de passe doit contenir 8 caractères minimum.';
            if (!value.contains(RegExp(r'\d')))
              return 'Votre mot de passe doit contenir au moins un chiffre.';
          }
          return null;
        },
        onChanged: (value) =>
            isEmail ? _user.email = value : _user.password = value,
        style: TextStyle(
          color: Colors.orange[200],
        ),
        obscureText: !isEmail,
      );

  ButtonTheme customButton({
    double size = 500,
    String content = "",
    Color color,
    double fontSize = 16.0,
    Color textColor = Colors.black,
    Function onPress,
  }) =>
      ButtonTheme(
        minWidth: size,
        buttonColor: color,
        child: RaisedButton(
          onPressed: () {
            onPress();
          },
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/background3.jpg'),
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
                    child: Image.asset('images/logo.png'),
                  ),
                  Expanded(
                    flex: 2,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          customTFF(
                            icon: Icons.email,
                            text: 'EMAIL',
                            validatorText: 'Veuillez entrer un email.',
                            isEmail: true,
                          ),
                          customTFF(
                            icon: Icons.lock,
                            text: 'MOT DE PASSE',
                            validatorText: 'Veuillez entrer un mot de passe.',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                              bottom: 10.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                customText(
                                    content: 'Mot de passe oublié ? ',
                                    size: 13),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: customButton(
                                color: Colors.white,
                                content: 'Connexion',
                                onPress: () {
                                  //Formulaire valide
                                  if (_formKey.currentState.validate()) {
                                    print("email : " + _user.email);
                                    print("password : " + _user.password);
                                  }
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: customButton(
                              color: Colors.red[600],
                              content: 'Google',
                              textColor: Colors.white,
                              onPress: () => print("Test google"),
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
