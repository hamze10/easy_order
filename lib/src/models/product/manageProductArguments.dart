import 'package:easy_order/src/models/product/product.dart';
import 'package:easy_order/src/models/suppliers/supplier.dart';

class ManageProductArguments {
  Product product;
  Supplier supplier;

  ManageProductArguments(this.product, this.supplier);
}
