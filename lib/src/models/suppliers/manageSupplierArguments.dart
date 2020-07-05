import 'package:easy_order/src/models/entreprise/entreprise.dart';
import 'package:easy_order/src/models/suppliers/supplier.dart';

class ManageSupplierArguments {
  Supplier supplier;
  Entreprise entreprise;

  ManageSupplierArguments(this.supplier, this.entreprise);
}
