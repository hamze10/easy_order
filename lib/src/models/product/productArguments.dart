import 'package:easy_order/src/models/product/product.dart';
import 'package:easy_order/src/models/suppliers/supplier.dart';

class ProductArguments {
  List<Product> products;
  Supplier supplier;

  ProductArguments(this.products, this.supplier);
}
