part of 'manage_product_bloc.dart';

@immutable
class ManageProductState {
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  ManageProductState({
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
  });

  factory ManageProductState.inital() {
    return ManageProductState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory ManageProductState.loading() {
    return ManageProductState(
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory ManageProductState.failure() {
    return ManageProductState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory ManageProductState.success() {
    return ManageProductState(
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  ManageProductState copyWith({
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return ManageProductState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return '''ManageProductState {
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}
