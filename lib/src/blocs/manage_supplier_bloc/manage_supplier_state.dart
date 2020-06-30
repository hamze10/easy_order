part of 'manage_supplier_bloc.dart';

@immutable
class ManageSupplierState {
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  ManageSupplierState({
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
  });

  factory ManageSupplierState.inital() {
    return ManageSupplierState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory ManageSupplierState.loading() {
    return ManageSupplierState(
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory ManageSupplierState.failure() {
    return ManageSupplierState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory ManageSupplierState.success() {
    return ManageSupplierState(
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  ManageSupplierState copyWith({
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return ManageSupplierState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return '''ManageSupplierState {
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}
