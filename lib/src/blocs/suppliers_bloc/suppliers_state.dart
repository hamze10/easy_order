part of 'suppliers_bloc.dart';

abstract class SuppliersState extends Equatable {
  const SuppliersState();

  @override
  List<Object> get props => [];
}

class SuppliersLoadInProgress extends SuppliersState {}

class SuppliersLoadSuccess extends SuppliersState {
  final List<Supplier> suppliers;

  const SuppliersLoadSuccess([this.suppliers = const []]);

  @override
  List<Object> get props => [suppliers];

  @override
  String toString() => 'SuppliersLoadSuccess {suppliers : $suppliers}';
}

class SuppliersLoadFailure extends SuppliersState {}
