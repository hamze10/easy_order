part of 'suppliers_bloc.dart';

abstract class SuppliersEvent extends Equatable {
  const SuppliersEvent();

  @override
  List<Object> get props => [];
}

class LoadSuppliers extends SuppliersEvent {
  final List<Supplier> suppliers;

  const LoadSuppliers(this.suppliers);

  @override
  List<Object> get props => [suppliers];
}

class SuppliersUpdated extends SuppliersEvent {
  final List<Supplier> suppliers;

  const SuppliersUpdated(this.suppliers);

  @override
  List<Object> get props => [suppliers];
}
