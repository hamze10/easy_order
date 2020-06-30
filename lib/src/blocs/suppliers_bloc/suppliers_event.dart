part of 'suppliers_bloc.dart';

abstract class SuppliersEvent extends Equatable {
  const SuppliersEvent();

  @override
  List<Object> get props => [];
}

class LoadSuppliers extends SuppliersEvent {
  final List<Supplier> suppliers;
  final Entreprise entreprise;

  const LoadSuppliers(this.suppliers, this.entreprise);

  @override
  List<Object> get props => [suppliers, entreprise];
}

class SuppliersUpdated extends SuppliersEvent {
  final List<Supplier> suppliers;
  final Entreprise entreprise;

  const SuppliersUpdated(this.suppliers, this.entreprise);

  @override
  List<Object> get props => [suppliers, entreprise];
}
