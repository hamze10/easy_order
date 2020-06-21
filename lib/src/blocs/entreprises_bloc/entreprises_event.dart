part of 'entreprises_bloc.dart';

@immutable
abstract class EntreprisesEvent {
  const EntreprisesEvent();

  @override
  List<Object> get props => [];
}

class LoadEntreprises extends EntreprisesEvent {}

class AddEntreprise extends EntreprisesEvent {
  final Entreprise entreprise;

  const AddEntreprise(this.entreprise);

  @override
  List<Object> get props => [entreprise];

  @override
  String toString() => 'AddEntreprise { entreprise : $entreprise }';
}

class UpdateEntreprise extends EntreprisesEvent {
  final Entreprise entreprise;

  const UpdateEntreprise(this.entreprise);

  @override
  List<Object> get props => [entreprise];

  @override
  String toString() => 'UpdateEntreprise { entreprise : $entreprise }';
}

class DeleteEntreprise extends EntreprisesEvent {
  final Entreprise entreprise;

  const DeleteEntreprise(this.entreprise);

  @override
  List<Object> get props => [entreprise];

  @override
  String toString() => 'DeleteEntreprise { entreprise : $entreprise }';
}

class EntrepriseUpdated extends EntreprisesEvent {
  final List<Entreprise> entreprise;

  const EntrepriseUpdated(this.entreprise);

  @override
  List<Object> get props => [entreprise];
}
