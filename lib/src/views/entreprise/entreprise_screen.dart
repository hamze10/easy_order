import 'package:easy_order/src/blocs/entreprises_bloc/entreprises_bloc.dart';
import 'package:easy_order/src/views/entreprise/entreprise_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EntrepriseScreen extends StatelessWidget {
  final String _displayName;

  EntrepriseScreen({Key key, @required String displayName})
      : assert(displayName != null),
        _displayName = displayName,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntreprisesBloc, EntreprisesState>(
      builder: (context, state) {
        if (state is EntreprisesLoadInProgress) {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.red,
                valueColor: AlwaysStoppedAnimation(Colors.red[100]),
              ),
            ),
          );
        } else if (state is EntreprisesLoadFailure) {
          return Container(
            color: Colors.white,
            child: Center(
              child: Text("Impossible de charger vos entreprises."),
            ),
          );
        } else if (state is EntreprisesLoadSuccess) {
          return EntrepriseList(
            entreprise: state.entreprises,
            displayName: _displayName,
          );
        } else {
          return Container();
        }
      },
    );
  }
}
