part of 'entreprises_bloc.dart';

@immutable
abstract class EntreprisesState extends Equatable {
  const EntreprisesState();

  @override
  List<Object> get props => [];
}

class EntreprisesLoadInProgress extends EntreprisesState {}

class EntreprisesLoadSuccess extends EntreprisesState {
  final List<Entreprise> entreprises;

  const EntreprisesLoadSuccess([this.entreprises = const []]);

  @override
  List<Object> get props => [entreprises];

  @override
  String toString() => 'EntreprisesLoadSuccess {entreprises : $entreprises }';
}

class EntreprisesLoadFailure extends EntreprisesState {}
