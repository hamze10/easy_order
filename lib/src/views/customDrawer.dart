import 'package:easy_order/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:easy_order/src/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String _displayName = "???";
  final UserRepository userRepository = UserRepository();

  _CustomDrawerState() {
    getEmail();
  }

  getEmail() async {
    return await userRepository.getUser().then((value) {
      setState(() {
        _displayName = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.teal[400],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  _displayName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 40.0,
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Deconnexion'),
            onTap: () {
              BlocProvider.of<AuthenticationBloc>(context).add(
                AuthenticationLoggedOut(),
              );
            },
          ),
        ],
      ),
    );
  }
}
