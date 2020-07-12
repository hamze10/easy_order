import 'package:easy_order/src/blocs/suppliers_bloc/suppliers_bloc.dart';
import 'package:easy_order/src/models/order.dart';
import 'package:easy_order/src/views/suppliers/supplier_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupplierScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Order suppliers = ModalRoute.of(context).settings.arguments as Order;

    BlocProvider.of<SuppliersBloc>(context)
      ..add(LoadSuppliers(suppliers.fromEntreprise, suppliers.entreprise));

    return BlocBuilder<SuppliersBloc, SuppliersState>(
      builder: (context, state) {
        if (state is SuppliersLoadInProgress) {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.teal,
                valueColor: AlwaysStoppedAnimation(Colors.teal[100]),
              ),
            ),
          );
        } else if (state is SuppliersLoadFailure) {
          return Container(
            color: Colors.white,
            child: Center(
              child: Text("Impossible de charger les fournisseurs."),
            ),
          );
        } else if (state is SuppliersLoadSuccess) {
          return SupplierList(
            suppliers: suppliers.copyWith(
                fromEntreprise: state.suppliers, entreprise: state.entreprise),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
