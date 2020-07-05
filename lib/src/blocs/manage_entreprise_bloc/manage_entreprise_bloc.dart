import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_order/src/models/entreprise/entreprise.dart';
import 'package:easy_order/src/repositories/entreprise/firebase_entreprise_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'manage_entreprise_event.dart';
part 'manage_entreprise_state.dart';

class ManageEntrepriseBloc
    extends Bloc<ManageEntrepriseEvent, ManageEntrepriseState> {
  final FirebaseEntrepriseRepository _entrepriseRepository;

  ManageEntrepriseBloc(
      {@required FirebaseEntrepriseRepository entrepriseRepository})
      : assert(entrepriseRepository != null),
        _entrepriseRepository = entrepriseRepository;

  @override
  ManageEntrepriseState get initialState => ManageEntrepriseState.inital();

  @override
  Stream<ManageEntrepriseState> mapEventToState(
    ManageEntrepriseEvent event,
  ) async* {
    if (event is AddEntreprise) {
      yield* _mapAddEntrepriseToState(event);
    } else if (event is UpdateEntreprise) {
      yield* _mapUpdateEntrepriseToState(event);
    } else if (event is DeleteEntreprise) {
      yield* _mapDeleteEntrepriseToState(event);
    }
  }

  Stream<ManageEntrepriseState> _mapAddEntrepriseToState(
      AddEntreprise event) async* {
    yield ManageEntrepriseState.loading();
    try {
      await _entrepriseRepository.addNewEntreprise(event.entreprise);
      yield ManageEntrepriseState.success();
    } catch (_) {
      yield ManageEntrepriseState.failure();
    }
  }

  Stream<ManageEntrepriseState> _mapUpdateEntrepriseToState(
      UpdateEntreprise event) async* {
    yield ManageEntrepriseState.loading();
    try {
      await _entrepriseRepository.updateEntreprise(event.entreprise);
      yield ManageEntrepriseState.success();
    } catch (_) {
      yield ManageEntrepriseState.failure();
    }
  }

  Stream<ManageEntrepriseState> _mapDeleteEntrepriseToState(
      DeleteEntreprise event) async* {
    yield ManageEntrepriseState.loading();
    try {
      await _entrepriseRepository.deleteNewEntreprise(event.entreprise);
      yield ManageEntrepriseState.success();
    } catch (_) {
      yield ManageEntrepriseState.failure();
    }
  }
}
