part of 'entreprises_bloc.dart';

@immutable
abstract class EntreprisesEvent {
  const EntreprisesEvent();

  @override
  // ignore: override_on_non_overriding_member
  List<Object> get props => [];
}

class LoadEntreprises extends EntreprisesEvent {}

class EntrepriseUpdated extends EntreprisesEvent {
  final List<Entreprise> entreprise;

  const EntrepriseUpdated(this.entreprise);

  @override
  List<Object> get props => [entreprise];
}
