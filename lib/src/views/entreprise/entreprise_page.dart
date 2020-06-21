import 'package:easy_order/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:easy_order/src/blocs/entreprises_bloc/entreprises_bloc.dart';
import 'package:easy_order/src/repositories/firebase_entreprise_repository.dart';
import 'package:easy_order/src/views/entreprise/entreprise_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EntreprisePage extends StatelessWidget {
  final FirebaseEntrepriseRepository _firebaseEntrepriseRepository;

  EntreprisePage({Key key, @required firebaseEntrepriseRepository})
      : assert(firebaseEntrepriseRepository != null),
        _firebaseEntrepriseRepository = firebaseEntrepriseRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<EntreprisesBloc>(
        create: (context) => EntreprisesBloc(
            entrepriseRepository: _firebaseEntrepriseRepository),
        child: EntrepriseList(
          firebaseEntrepriseRepository: _firebaseEntrepriseRepository,
        ),
      ),
    );
  }

  /*@override
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
      body: BlocBuilder<EntreprisesBloc, EntreprisesState>(
        builder: (context, state) {
          if (state is EntreprisesLoadInProgress) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is EntreprisesLoadFailure) {
            return Center(
              child: Text('Impossible de charger vos entreprises.'),
            );
          } else if (state is EntreprisesLoadSuccess) {
            final entreprises = state.entreprises;
            return EntrepriseList(
              entreprises: entreprises,
            );
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        backgroundColor: Colors.red[400],
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }*/
}
