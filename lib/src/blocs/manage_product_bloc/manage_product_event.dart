part of 'manage_product_bloc.dart';

abstract class ManageProductEvent extends Equatable {
  const ManageProductEvent();

  @override
  List<Object> get props => [];
}

class AddProduct extends ManageProductEvent {
  final Product product;
  final Supplier supplier;

  const AddProduct(this.product, this.supplier);

  @override
  List<Object> get props => [product, supplier];

  @override
  String toString() =>
      'AddProduct { product : $product, supplier : $supplier }';
}

class AddMultipleProduct extends ManageProductEvent {
  final List<Product> products;
  final Supplier supplier;

  const AddMultipleProduct(this.products, this.supplier);

  @override
  List<Object> get props => [products, supplier];

  @override
  String toString() =>
      'AddProduct { products : $products, supplier : $supplier }';
}

class UpdateProduct extends ManageProductEvent {
  final Product product;

  const UpdateProduct(this.product);

  @override
  List<Object> get props => [product];

  @override
  String toString() => 'UpdateProduct { product : $product }';
}

class DeleteProduct extends ManageProductEvent {
  final Product product;
  final Supplier supplier;

  const DeleteProduct(this.product, this.supplier);

  @override
  List<Object> get props => [product, supplier];

  @override
  String toString() =>
      'DeleteProduct { product : $product, supplier : $supplier }';
}
