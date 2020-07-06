import 'package:easy_order/src/blocs/manage_product_bloc/manage_product_bloc.dart';
import 'package:easy_order/src/models/product/manageProductArguments.dart';
import 'package:easy_order/src/repositories/product/firebase_product_repository.dart';
import 'package:easy_order/src/views/products/manage_product_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageProductScreen extends StatelessWidget {
  final FirebaseProductRepository _productRepository;

  ManageProductScreen({
    Key key,
    @required FirebaseProductRepository productRepository,
  })  : assert(productRepository != null),
        _productRepository = productRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final ManageProductArguments editingProd =
        ModalRoute.of(context).settings.arguments as ManageProductArguments;

    return BlocProvider<ManageProductBloc>(
      create: (context) =>
          ManageProductBloc(productRepository: _productRepository),
      child: ManageProductForm(
        productRepository: _productRepository,
        manageProductArguments: editingProd,
      ),
    );
  }
}
