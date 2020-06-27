part of 'manage_entreprise_bloc.dart';

@immutable
class ManageEntrepriseState {
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  ManageEntrepriseState({
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
  });

  factory ManageEntrepriseState.inital() {
    return ManageEntrepriseState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory ManageEntrepriseState.loading() {
    return ManageEntrepriseState(
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory ManageEntrepriseState.failure() {
    return ManageEntrepriseState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory ManageEntrepriseState.success() {
    return ManageEntrepriseState(
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  ManageEntrepriseState copyWith({
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return ManageEntrepriseState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return '''ManageEntrepriseState {
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}
