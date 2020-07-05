import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_order/src/models/entreprise/entreprise.dart';
import 'package:easy_order/src/models/suppliers/supplier.dart';
import 'package:easy_order/src/repositories/supplier/firebase_supplier_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'manage_supplier_event.dart';
part 'manage_supplier_state.dart';

class ManageSupplierBloc
    extends Bloc<ManageSupplierEvent, ManageSupplierState> {
  final FirebaseSupplierRepository _supplierRepository;

  ManageSupplierBloc({
    @required FirebaseSupplierRepository supplierRepository,
  })  : assert(supplierRepository != null),
        _supplierRepository = supplierRepository;

  @override
  ManageSupplierState get initialState => ManageSupplierState.inital();

  @override
  Stream<ManageSupplierState> mapEventToState(
    ManageSupplierEvent event,
  ) async* {
    if (event is AddSupplier) {
      yield* _mapAddSupplierToState(event);
    } else if (event is UpdateSupplier) {
      yield* _mapUpdateSupplierToState(event);
    } else if (event is DeleteSupplier) {
      yield* _mapDeleteSupplierToState(event);
    }
  }

  Stream<ManageSupplierState> _mapAddSupplierToState(AddSupplier event) async* {
    yield ManageSupplierState.loading();
    try {
      await _supplierRepository.addNewSupplier(
          event.supplier, event.entreprise);
      yield ManageSupplierState.success();
    } catch (_) {
      yield ManageSupplierState.failure();
    }
  }

  Stream<ManageSupplierState> _mapUpdateSupplierToState(
      UpdateSupplier event) async* {
    yield ManageSupplierState.loading();
    try {
      await _supplierRepository.updateSupplier(event.supplier);
      yield ManageSupplierState.success();
    } catch (_) {
      yield ManageSupplierState.failure();
    }
  }

  Stream<ManageSupplierState> _mapDeleteSupplierToState(
      DeleteSupplier event) async* {
    yield ManageSupplierState.loading();
    try {
      await _supplierRepository.deleteSupplier(
          event.supplier, event.entreprise);
      yield ManageSupplierState.success();
    } catch (_) {
      yield ManageSupplierState.failure();
    }
  }
}
