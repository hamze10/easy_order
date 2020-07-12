import 'package:easy_order/src/blocs/products_bloc/products_bloc.dart';
import 'package:easy_order/src/models/order.dart';
import 'package:easy_order/src/views/products/product_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Order products = ModalRoute.of(context).settings.arguments as Order;

    BlocProvider.of<ProductsBloc>(context)
      ..add(LoadProducts(products.fromSupplier, products.supplier));

    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoadInProgress) {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.teal,
                valueColor: AlwaysStoppedAnimation(Colors.teal[100]),
              ),
            ),
          );
        } else if (state is ProductsLoadFailure) {
          return Container(
            color: Colors.white,
            child: Center(
              child: Text('Impossible de charger les produits.'),
            ),
          );
        } else if (state is ProductsLoadSuccess) {
          return ProductList(
            products: products.copyWith(
                fromSupplier: state.products, supplier: state.supplier),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
