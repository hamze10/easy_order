import 'package:easy_order/src/models/entreprise/entreprise.dart';
import 'package:easy_order/src/models/product/product.dart';
import 'package:easy_order/src/models/suppliers/supplier.dart';

class Order {
  final String nameUser;
  final Entreprise entreprise;
  final List<Supplier> fromEntreprise;
  final Supplier supplier;
  final List<Product> fromSupplier;
  final Product product;
  final int quantity;

  Order({
    this.nameUser,
    this.entreprise,
    this.fromEntreprise,
    this.supplier,
    this.fromSupplier,
    this.product,
    this.quantity,
  });

  Order copyWith({
    String nameUser,
    Entreprise entreprise,
    List<Supplier> fromEntreprise,
    Supplier supplier,
    List<Product> fromSupplier,
    Product product,
    int quantity,
  }) {
    return Order(
      nameUser: nameUser ?? this.nameUser,
      entreprise: entreprise ?? this.entreprise,
      fromEntreprise: fromEntreprise ?? this.fromEntreprise,
      supplier: supplier ?? this.supplier,
      fromSupplier: fromSupplier ?? this.fromSupplier,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  String toSend() {
    return '[${product.name} - quantité: $quantity], ';
  }

  @override
  String toString() =>
      'Order {nameUser : $nameUser, entreprise : $entreprise, fromEntreprise : $fromEntreprise, supplier : $supplier, fromSupplier : $fromSupplier, product : $product, quantity : $quantity }';
}
