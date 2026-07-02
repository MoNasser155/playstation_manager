part of 'add_supplier_cubit.dart';

class AddSupplierState extends Equatable {
  final StateStatus status;
  final String? errMessage;

  const AddSupplierState({
    required this.status,
    this.errMessage,
  });

  AddSupplierState copyWith({
    StateStatus? status,
    String? errMessage,
  }) {
    return AddSupplierState(
      status: status ?? this.status,
      errMessage: errMessage ?? this.errMessage,
    );
  }

  factory AddSupplierState.initial() =>
      const AddSupplierState(status: StateStatus.initial);

  @override
  List<Object?> get props => [status, errMessage];
}
