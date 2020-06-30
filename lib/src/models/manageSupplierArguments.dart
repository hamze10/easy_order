import 'package:easy_order/src/models/entreprise.dart';
import 'package:easy_order/src/models/supplier.dart';

class ManageSupplierArguments {
  Supplier supplier;
  Entreprise entreprise;

  ManageSupplierArguments(this.supplier, this.entreprise);
}
