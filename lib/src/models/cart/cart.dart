import 'package:easy_order/src/models/order.dart';
import 'package:easy_order/src/models/product/product.dart';
import 'package:flutter/foundation.dart';

class CartModel extends ChangeNotifier {
  Order _order;

  final List<Product> _products = [];

  Order get order => _order;
  List<Product> get products => _products;

  set order(Order newOrder) {
    assert(newOrder != null);
    _order = newOrder;
    notifyListeners();
  }

  double get totalPrice => _products.fold(
      0, (previousValue, element) => previousValue + element.price);

  void add(Product product) {
    _products.add(product);
    notifyListeners();
  }
}
