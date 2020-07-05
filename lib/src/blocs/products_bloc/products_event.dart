part of 'products_bloc.dart';

@immutable
abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductsEvent {
  final List<Product> products;
  final Supplier supplier;

  const LoadProducts(this.products, this.supplier);

  @override
  List<Object> get props => [products, supplier];
}

class ProductsUpdated extends ProductsEvent {
  final List<Product> products;
  final Supplier supplier;

  const ProductsUpdated(this.products, this.supplier);

  @override
  List<Object> get props => [products, supplier];
}
