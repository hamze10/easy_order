part of 'manage_entreprise_bloc.dart';

abstract class ManageEntrepriseEvent extends Equatable {
  const ManageEntrepriseEvent();

  @override
  List<Object> get props => [];
}

class AddEntreprise extends ManageEntrepriseEvent {
  final Entreprise entreprise;

  const AddEntreprise(this.entreprise);

  @override
  List<Object> get props => [entreprise];

  @override
  String toString() => 'AddEntreprise { entreprise : $entreprise }';
}

class UpdateEntreprise extends ManageEntrepriseEvent {
  final Entreprise entreprise;

  const UpdateEntreprise(this.entreprise);

  @override
  List<Object> get props => [entreprise];

  @override
  String toString() => 'UpdateEntreprise { entreprise : $entreprise }';
}

class DeleteEntreprise extends ManageEntrepriseEvent {
  final Entreprise entreprise;

  const DeleteEntreprise(this.entreprise);

  @override
  List<Object> get props => [entreprise];

  @override
  String toString() => 'DeleteEntreprise { entreprise : $entreprise }';
}
