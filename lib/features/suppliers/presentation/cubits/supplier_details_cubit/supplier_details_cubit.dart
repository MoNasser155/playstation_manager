import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/enums/state_status.dart';
import '../../../../../core/enums/user_type.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/shared/cubits/base_cubit_emiter.dart';
import '../../../../../core/shared/di.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/navigator_helper.dart';
import '../../../../../core/widgets/custom_snack_bar.dart';
import '../../../../main_view/presentation/cubits/main_view_cubit/main_view_cubit.dart';
import '../../../../transactions/data/models/transaction_model.dart';
import '../../../../transactions/domain/usecases/get_all_user_transactions_usecase.dart';
import '../../../data/models/supplier_details_model.dart';
import '../../../data/models/supplier_model.dart';
import '../../../domain/usecases/delete_supplier_usecase.dart';
import '../../../domain/usecases/get_supplier_details_usecase.dart';
import '../../../domain/usecases/update_supplier_usecase.dart';

part 'supplier_details_state.dart';

class SupplierDetailsCubit extends BaseCubit<SupplierDetailsState> {
  SupplierDetailsCubit() : super(SupplierDetailsState.initial());

  static SupplierDetailsCubit get(context) => BlocProvider.of(context);

  final _getSupplierDetailsUseCase = sl<GetSupplierDetailsUseCase>();
  final _deleteSupplierUseCase = sl<DeleteSupplierUseCase>();
  final _updateSupplierUseCase = sl<UpdateSupplierUseCase>();
  final _getAllUserTransactionsUseCase = sl<GetAllUserTransactionsUseCase>();

  late TextEditingController nameController;
  late TextEditingController phone1Controller;
  late TextEditingController phone2Controller;
  late TextEditingController addressController;
  final formKey = GlobalKey<FormState>();

  void setupControllers() {
    nameController = TextEditingController(
      text: state.supplierDetails.supplier.name,
    );
    phone1Controller = TextEditingController(
      text: state.supplierDetails.supplier.phone1,
    );
    phone2Controller = TextEditingController(
      text: state.supplierDetails.supplier.phone2,
    );
    addressController = TextEditingController(
      text: state.supplierDetails.supplier.address,
    );
  }

  void init(String supplierUuid) async {
    safeEmit(
      state.copyWith(status: StateStatus.loading, supplierUuid: supplierUuid),
    );
    await Future.wait([_getSupplierDetails(), _getAllTransactions()]);
  }

  Future<void> _getSupplierDetails() async {
    safeEmit(state.copyWith(status: StateStatus.loading));
    final result = await _getSupplierDetailsUseCase.call(state.supplierUuid);
    result.fold(
      (failure) {
        safeEmit(state.copyWith(status: StateStatus.failure));
      },
      (supplierDetails) {
        safeEmit(
          state.copyWith(
            status: StateStatus.success,
            supplierDetails: supplierDetails,
          ),
        );
      },
    );
  }

  Future<void> deleteSupplier(BuildContext context) async {
    safeEmit(state.copyWith(status: StateStatus.loading));
    final result = await _deleteSupplierUseCase(state.supplierUuid);
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
        final cubit = MainViewCubit.get(context);
        cubit.clearCustomizedView();
      },
    );
  }

  Future<void> _getAllTransactions() async {
    safeEmit(state.copyWith(transactionsState: StateStatus.loading));
    final result = await _getAllUserTransactionsUseCase.call(
      type: UserType.supplier,
      uuid: state.supplierUuid,
    );
    result.fold(
      (failure) {
        safeEmit(state.copyWith(transactionsState: StateStatus.failure));
      },
      (transactions) {
        safeEmit(
          state.copyWith(
            transactionsState: StateStatus.success,
            transactions: transactions,
          ),
        );
      },
    );
  }

  Future<void> updateCustomer(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    safeEmit(state.copyWith(status: StateStatus.loading));
    final result = await _updateSupplierUseCase(
      SupplierModel(
        uuid: state.supplierUuid,
        name: nameController.text,
        phone1: phone1Controller.text,
        phone2: phone2Controller.text,
        address: addressController.text,
        receivableAmount: state.supplierDetails.supplier.receivableAmount,
        payableAmount: state.supplierDetails.supplier.payableAmount,
        id: state.supplierDetails.supplier.id,
      ),
    );
    result.fold(
      (failure) {
        safeEmit(state.copyWith(status: StateStatus.failure));
        CustomSnackBar.top(context: context, msg: failure.message);
      },
      (r) {
        safeEmit(state.copyWith(status: StateStatus.success));
        CustomSnackBar.top(
          context: context,
          msg: LocaleKeys.supplierUpdatedSuccessfully,
          color: AppColors.successColor,
        );
        AppNavigator.pop();
        refresh();
      },
    );
  }

  void refresh() async {
    safeEmit(state.copyWith(status: StateStatus.loading));
    await Future.wait([_getSupplierDetails(), _getAllTransactions()]);
  }
}
