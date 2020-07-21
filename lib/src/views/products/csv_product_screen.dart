import 'package:easy_order/src/blocs/manage_product_bloc/manage_product_bloc.dart';
import 'package:easy_order/src/models/product/manageProductArguments.dart';
import 'package:easy_order/src/repositories/product/firebase_product_repository.dart';
import 'package:easy_order/src/views/products/csv_product_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CSVProductScreen extends StatelessWidget {
  final FirebaseProductRepository _productRepository;

  CSVProductScreen(this._productRepository);

  @override
  Widget build(BuildContext context) {
    final ManageProductArguments editingProd =
        ModalRoute.of(context).settings.arguments as ManageProductArguments;

    return BlocProvider<ManageProductBloc>(
      create: (context) =>
          ManageProductBloc(productRepository: _productRepository),
      child: CSVProductForm(editingProd),
    );
  }
}
