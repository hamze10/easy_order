import 'package:easy_order/src/models/entreprise.dart';
import 'package:easy_order/src/models/supplier.dart';

class SupplierArguments {
  List<Supplier> suppliers;
  Entreprise entreprise;

  SupplierArguments(this.suppliers, this.entreprise);
}
