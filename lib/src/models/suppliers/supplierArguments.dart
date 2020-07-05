import 'package:easy_order/src/models/entreprise/entreprise.dart';
import 'package:easy_order/src/models/suppliers/supplier.dart';

class SupplierArguments {
  List<Supplier> suppliers;
  Entreprise entreprise;

  SupplierArguments(this.suppliers, this.entreprise);
}
