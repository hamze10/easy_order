import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_order/src/models/entreprise.dart';
import 'package:easy_order/src/models/supplier.dart';
import 'package:easy_order/src/repositories/firebase_supplier_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'suppliers_event.dart';
part 'suppliers_state.dart';

class SuppliersBloc extends Bloc<SuppliersEvent, SuppliersState> {
  final FirebaseSupplierRepository _supplierRepository;
  StreamSubscription _supplierSubscription;

  SuppliersBloc({
    @required FirebaseSupplierRepository supplierRepository,
  })  : assert(supplierRepository != null),
        _supplierRepository = supplierRepository;

  @override
  SuppliersState get initialState => SuppliersLoadInProgress();

  @override
  Stream<SuppliersState> mapEventToState(
    SuppliersEvent event,
  ) async* {
    if (event is LoadSuppliers) {
      yield* _mapLoadSuppliersToState(event);
    } else if (event is SuppliersUpdated) {
      yield* _mapSuppliersUpdateToState(event);
    }
  }

  Stream<SuppliersState> _mapLoadSuppliersToState(LoadSuppliers event) async* {
    Entreprise ent = event.entreprise;
    _supplierSubscription?.cancel();
    _supplierSubscription = _supplierRepository
        .suppliers(event.suppliers)
        .listen((supplier) => add(SuppliersUpdated(supplier, ent)));
  }

  Stream<SuppliersState> _mapSuppliersUpdateToState(
      SuppliersUpdated event) async* {
    yield SuppliersLoadSuccess(event.suppliers, event.entreprise);
  }

  @override
  Future<void> close() {
    _supplierSubscription?.cancel();
    return super.close();
  }
}
