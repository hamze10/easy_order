part of 'entreprises_bloc.dart';

@immutable
abstract class EntreprisesEvent extends Equatable {
  const EntreprisesEvent();

  @override
  List<Object> get props => [];
}

class LoadEntreprises extends EntreprisesEvent {}

class EntrepriseUpdated extends EntreprisesEvent {
  final List<Entreprise> entreprise;

  const EntrepriseUpdated(this.entreprise);

  @override
  List<Object> get props => [entreprise];
}
