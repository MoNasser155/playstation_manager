import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/enums/state_status.dart';
import '../../../../../core/shared/cubits/base_cubit_emiter.dart';
import '../../../../../core/shared/di.dart';
import '../../../../../core/utils/navigator_helper.dart';
import '../../../../../core/widgets/custom_snack_bar.dart';
import '../../../data/models/supplier_model.dart';
import '../../../domain/usecases/delete_supplier_usecase.dart';
import '../../../domain/usecases/get_all_suppliers_usecase.dart';
import '../../../domain/usecases/update_supplier_usecase.dart';

part 'suppliers_state.dart';

class SuppliersCubit extends BaseCubit<SuppliersState> {
  SuppliersCubit() : super(SuppliersState.initial());

  static SuppliersCubit get(context) => BlocProvider.of(context);

  final _getAllSuppliersUseCase = sl<GetAllSuppliersUseCase>();
  final _deleteSupplierUseCase = sl<DeleteSupplierUseCase>();
  final _updateSupplierUseCase = sl<UpdateSupplierUseCase>();

  final searchController = TextEditingController();

  Future<void> getAllSuppliers() async {
    safeEmit(state.copyWith(status: StateStatus.loading));
    final result = await _getAllSuppliersUseCase();
    result.fold(
      (failure) {
        safeEmit(
          state.copyWith(
            status: StateStatus.failure,
            errMessage: failure.message,
          ),
        );
      },
      (suppliers) {
        safeEmit(
          state.copyWith(status: StateStatus.success, suppliers: suppliers),
        );
      },
    );
  }

  Future<void> updateSupplier(SupplierModel supplier) async {
    safeEmit(state.copyWith(status: StateStatus.loading));
    final result = await _updateSupplierUseCase(supplier);
    result.fold(
      (failure) {
        safeEmit(
          state.copyWith(
            status: StateStatus.failure,
            errMessage: failure.message,
          ),
        );
      },
      (r) {
        safeEmit(state.copyWith(status: StateStatus.success));
        getAllSuppliers();
      },
    );
  }

  Future<void> deleteSupplier(String uuid, BuildContext context) async {
    safeEmit(state.copyWith(status: StateStatus.loading));
    final result = await _deleteSupplierUseCase(uuid);
    result.fold(
      (failure) {
        safeEmit(
          state.copyWith(
            status: StateStatus.failure,
            errMessage: failure.message,
          ),
        );
        CustomSnackBar.top(context: context, msg: failure.message);
      },
      (r) {
        safeEmit(state.copyWith(status: StateStatus.success));
        getAllSuppliers();
        AppNavigator.pop(result: true);
      },
    );
  }

  void refresh() {
    getAllSuppliers();
  }

  void searchOnSuppliers() {
    if (searchController.text.isEmpty) {
      safeEmit(state.copyWith(filteredSuppliers: []));
    } else {
      final filteredSuppliers =
          state.suppliers
              .where(
                (supplier) => supplier.name.toLowerCase().contains(
                  searchController.text.toLowerCase(),
                ),
              )
              .toList();
      safeEmit(state.copyWith(filteredSuppliers: filteredSuppliers));
    }
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}
