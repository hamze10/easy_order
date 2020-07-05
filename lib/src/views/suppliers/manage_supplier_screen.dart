import 'package:easy_order/src/blocs/manage_supplier_bloc/manage_supplier_bloc.dart';
import 'package:easy_order/src/models/suppliers/manageSupplierArguments.dart';
import 'package:easy_order/src/repositories/supplier/firebase_supplier_repository.dart';
import 'package:easy_order/src/views/suppliers/manage_supplier_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageSupplierScreen extends StatelessWidget {
  final FirebaseSupplierRepository _supplierRepository;

  ManageSupplierScreen({
    Key key,
    @required FirebaseSupplierRepository supplierRepository,
  })  : assert(supplierRepository != null),
        _supplierRepository = supplierRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final ManageSupplierArguments editingSupp =
        ModalRoute.of(context).settings.arguments as ManageSupplierArguments;

    return BlocProvider<ManageSupplierBloc>(
      create: (context) =>
          ManageSupplierBloc(supplierRepository: _supplierRepository),
      child: ManageSupplierForm(
        supplierRepository: _supplierRepository,
        manageSupplierArguments: editingSupp,
      ),
    );
  }
}
