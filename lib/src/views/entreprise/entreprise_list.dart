import 'package:easy_order/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:easy_order/src/models/entreprise.dart';
import 'package:easy_order/src/repositories/firebase_entreprise_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EntrepriseList extends StatefulWidget {
  final FirebaseEntrepriseRepository _firebaseEntrepriseRepository;

  EntrepriseList(
      {Key key,
      @required FirebaseEntrepriseRepository firebaseEntrepriseRepository})
      : assert(firebaseEntrepriseRepository != null),
        _firebaseEntrepriseRepository = firebaseEntrepriseRepository,
        super(key: key);

  @override
  _EntrepriseListState createState() => _EntrepriseListState();
}

class _EntrepriseListState extends State<EntrepriseList> {
  FirebaseEntrepriseRepository get _repo =>
      widget._firebaseEntrepriseRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        title: Text('Mes Entreprises'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(
                AuthenticationLoggedOut(),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        backgroundColor: Colors.red[300],
        child: Icon(Icons.add),
      ),
    );
  }
}
