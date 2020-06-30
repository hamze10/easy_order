import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_order/src/models/entreprise.dart';
import 'package:easy_order/src/repositories/firebase_entreprise_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'entreprises_event.dart';
part 'entreprises_state.dart';

class EntreprisesBloc extends Bloc<EntreprisesEvent, EntreprisesState> {
  final FirebaseEntrepriseRepository _entrepriseRepository;
  StreamSubscription _entrepriseSubscription;

  EntreprisesBloc({@required FirebaseEntrepriseRepository entrepriseRepository})
      : assert(entrepriseRepository != null),
        _entrepriseRepository = entrepriseRepository;

  @override
  EntreprisesState get initialState => EntreprisesLoadInProgress();

  @override
  Stream<EntreprisesState> mapEventToState(
    EntreprisesEvent event,
  ) async* {
    if (event is LoadEntreprises) {
      yield* _mapLoadEntreprisesToState();
    } else if (event is EntrepriseUpdated) {
      yield* _mapEntreprisesUpdateToState(event);
    }
  }

  Stream<EntreprisesState> _mapLoadEntreprisesToState() async* {
    _entrepriseSubscription?.cancel();
    _entrepriseSubscription = _entrepriseRepository
        .entreprises()
        .listen((entreprise) => add(EntrepriseUpdated(entreprise)));
  }

  Stream<EntreprisesState> _mapEntreprisesUpdateToState(
      EntrepriseUpdated event) async* {
    yield EntreprisesLoadSuccess(event.entreprise);
  }

  @override
  Future<void> close() {
    _entrepriseSubscription?.cancel();
    return super.close();
  }
}
