part of 'suppliers_bloc.dart';

abstract class SuppliersState extends Equatable {
  const SuppliersState();

  @override
  List<Object> get props => [];
}

class SuppliersLoadInProgress extends SuppliersState {}

class SuppliersLoadSuccess extends SuppliersState {
  final List<Supplier> suppliers;
  final Entreprise entreprise;

  const SuppliersLoadSuccess([this.suppliers = const [], this.entreprise]);

  @override
  List<Object> get props => [suppliers, entreprise];

  @override
  String toString() =>
      'SuppliersLoadSuccess {suppliers : $suppliers, entreprise : $entreprise}';
}

class SuppliersLoadFailure extends SuppliersState {}
