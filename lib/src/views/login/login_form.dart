import 'package:easy_order/src/blocs/blocs.dart';
import 'package:easy_order/src/repositories/user/user_repository.dart';
import 'package:easy_order/src/views/login/google_login_button.dart';
import 'package:easy_order/src/views/login/login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  LoginForm({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) =>
      state.isFormValid && isPopulated && !state.isSubmitting;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onLoginEmailChanged);
    _passwordController.addListener(_onLoginPasswordChanged);
  }

  void _onLoginEmailChanged() {
    _loginBloc.add(
      LoginEmailChanged(email: _emailController.text),
    );
  }

  void _onLoginPasswordChanged() {
    _loginBloc.add(
      LoginPasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Inscription'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('EasyOrder est actuellement en phase de test.'),
                Text(
                    'Vous recevrez une notification lorsque EasyOrder sera prêt !'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('D\'accord.'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Echec de connexion'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red[300],
              ),
            );
        }
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Connexion en cours ...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context)
              .add(AuthenticationLoggedIn());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return SafeArea(
            child: Container(
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
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                labelText: 'EMAIL',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                errorStyle: TextStyle(
                                  color: Colors.red[900],
                                ),
                                focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red[900],
                                  ),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red[900],
                                  ),
                                ),
                                suffixIcon: Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autovalidate: true,
                              autocorrect: false,
                              validator: (_) {
                                return !state.isEmailValid
                                    ? 'Veuillez entrez un email valide.'
                                    : null;
                              },
                              style: TextStyle(
                                color: Colors.orange[200],
                              ),
                            ),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                labelText: 'MOT DE PASSE',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                errorStyle: TextStyle(
                                  color: Colors.red[900],
                                ),
                                focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red[900],
                                  ),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red[900],
                                  ),
                                ),
                                suffixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                ),
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              autovalidate: true,
                              autocorrect: false,
                              validator: (_) {
                                return !state.isPasswordValid
                                    ? 'Veuillez entrer un mot de passe.'
                                    : null;
                              },
                              style: TextStyle(
                                color: Colors.orange[200],
                              ),
                              obscureText: true,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10.0,
                                bottom: 10.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    'Mot de passe oublié ?',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: LoginButton(
                                onPressed: isLoginButtonEnabled(state)
                                    ? _onFormSubmitted
                                    : null,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: GoogleLoginButton(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Pas de compte ? ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _showMyDialog,
                                    child: Text(
                                      'créer un nouveau compte.',
                                      style: TextStyle(
                                        color: Colors.orange[200],
                                        fontWeight: FontWeight.bold,
                                      ),
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
          );
        },
      ),
    );
  }
}
