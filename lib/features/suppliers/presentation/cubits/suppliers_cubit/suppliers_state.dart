part of 'suppliers_cubit.dart';

class SuppliersState extends Equatable {
  final StateStatus status;
  final List<SupplierModel> suppliers;
  final List<SupplierModel> filteredSuppliers;
  final String? errMessage;

  const SuppliersState({
    required this.status,
    required this.suppliers,
    required this.filteredSuppliers,
    this.errMessage,
  });

  SuppliersState copyWith({
    StateStatus? status,
    List<SupplierModel>? suppliers,
    List<SupplierModel>? filteredSuppliers,
    String? errMessage,
  }) {
    return SuppliersState(
      status: status ?? this.status,
      suppliers: suppliers ?? this.suppliers,
      filteredSuppliers: filteredSuppliers ?? this.filteredSuppliers,
      errMessage: errMessage ?? this.errMessage,
    );
  }

  factory SuppliersState.initial() => const SuppliersState(
    status: StateStatus.initial,
    suppliers: [],
    filteredSuppliers: [],
  );

  @override
  List<Object?> get props => [status, suppliers, filteredSuppliers, errMessage];
}
