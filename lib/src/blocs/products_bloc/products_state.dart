part of 'products_bloc.dart';

@immutable
abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

class ProductsLoadInProgress extends ProductsState {}

class ProductsLoadSuccess extends ProductsState {
  final List<Product> products;
  final Supplier supplier;

  const ProductsLoadSuccess(this.products, this.supplier);

  @override
  List<Object> get props => [products, supplier];

  @override
  String toString() =>
      'ProductsLoadInProgress {products : $products, supplier : $supplier}';
}

class ProductsLoadFailure extends ProductsState {}
