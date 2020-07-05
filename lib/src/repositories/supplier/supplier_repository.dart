import 'package:easy_order/src/models/entreprise/entreprise.dart';
import 'package:easy_order/src/models/suppliers/supplier.dart';

abstract class SupplierRepository {
  Future<void> addNewSupplier(Supplier supplier, Entreprise entreprise);
  Future<void> deleteSupplier(Supplier supplier, Entreprise entreprise);
  Future<void> updateSupplier(Supplier supplier);
  Stream<List<Supplier>> suppliers(List<Supplier> fromEntreprise);
}
