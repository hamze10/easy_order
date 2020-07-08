import 'package:easy_order/src/models/product/product.dart';
import 'package:easy_order/src/models/suppliers/supplier.dart';

abstract class ProductRepository {
  Future<void> addProduct(Product product, Supplier supplier);
  Future<void> deleteProduct(Product product, Supplier supplier);
  Stream<List<Product>> products(String idSupplier);
  Future<void> updateProduct(Product product);
}
