part of 'manage_supplier_bloc.dart';

abstract class ManageSupplierEvent extends Equatable {
  const ManageSupplierEvent();

  @override
  List<Object> get props => [];
}

class AddSupplier extends ManageSupplierEvent {
  final Supplier supplier;
  final Entreprise entreprise;

  const AddSupplier(this.supplier, this.entreprise);

  @override
  List<Object> get props => [supplier, entreprise];

  @override
  String toString() =>
      'AddSupplier { supplier : $supplier, entreprise : $entreprise }';
}

class UpdateSupplier extends ManageSupplierEvent {
  final Supplier supplier;

  const UpdateSupplier(this.supplier);

  @override
  List<Object> get props => [supplier];

  @override
  String toString() => 'UpdateSupplier { supplier : $supplier }';
}

class DeleteSupplier extends ManageSupplierEvent {
  final Supplier supplier;
  final Entreprise entreprise;

  const DeleteSupplier(this.supplier, this.entreprise);

  @override
  List<Object> get props => [supplier, entreprise];

  @override
  String toString() =>
      'DeleteSupplier { supplier : $supplier, entreprise : $entreprise }';
}
