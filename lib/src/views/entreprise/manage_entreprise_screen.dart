import 'package:easy_order/src/blocs/manage_entreprise_bloc/manage_entreprise_bloc.dart';
import 'package:easy_order/src/models/entreprise.dart';
import 'package:easy_order/src/repositories/firebase_entreprise_repository.dart';
import 'package:easy_order/src/views/entreprise/manage_entreprise_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageEntrepriseScreen extends StatelessWidget {
  final FirebaseEntrepriseRepository _entrepriseRepository;

  ManageEntrepriseScreen(
      {Key key, @required FirebaseEntrepriseRepository entrepriseRepository})
      : assert(entrepriseRepository != null),
        _entrepriseRepository = entrepriseRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final Entreprise editingEnt =
        ModalRoute.of(context).settings.arguments as Entreprise;

    return BlocProvider<ManageEntrepriseBloc>(
      create: (context) =>
          ManageEntrepriseBloc(entrepriseRepository: _entrepriseRepository),
      child: ManageEntrepriseForm(
        entrepriseRepository: _entrepriseRepository,
        entreprise: editingEnt,
      ),
    );
  }
}
