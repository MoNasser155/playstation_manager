import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/enums/state_status.dart';

import '../../../../../../core/shared/cubits/base_cubit_emiter.dart';
import '../../../../../../core/shared/di.dart';
import '../../../../../../core/widgets/custom_snack_bar.dart';
import '../../../../../core/enums/user_type.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/navigator_helper.dart';
import '../../../../invoices/data/models/create_invoice_model.dart';
import '../../../../invoices/domain/usecases/get_customer_invoices_usecase.dart';
import '../../../../main_view/presentation/cubits/main_view_cubit/main_view_cubit.dart';
import '../../../../transactions/data/models/transaction_model.dart';
import '../../../../transactions/domain/usecases/get_all_user_transactions_usecase.dart';
import '../../../data/models/customer_details_model.dart';
import '../../../data/models/customer_model.dart';
import '../../../domain/usecases/delete_customer_usecase.dart';
import '../../../domain/usecases/get_customer_details_usecase.dart';
import '../../../domain/usecases/update_customer_usecase.dart';

part 'customer_details_state.dart';

class CustomerDetailsCubit extends BaseCubit<CustomerDetailsState> {
  CustomerDetailsCubit() : super(CustomerDetailsState.initial());

  static CustomerDetailsCubit get(context) => BlocProvider.of(context);

  final _getCustomerDetailsUseCase = sl<GetCustomerDetailsUseCase>();
  final _deleteCustomerUseCase = sl<DeleteCustomerUseCase>();
  final _updateCustomerUseCase = sl<UpdateCustomerUseCase>();
  final _getAllUserTransactionsUseCase = sl<GetAllUserTransactionsUseCase>();
  final _getCustomerInvoicesUsecase = sl<GetCustomerInvoicesUseCase>();

  late TextEditingController nameController;
  late TextEditingController phone1Controller;
  late TextEditingController phone2Controller;
  late TextEditingController addressController;
  final formKey = GlobalKey<FormState>();

  void setupControllers() {
    nameController = TextEditingController(
      text: state.customerDetails.customer.name,
    );
    phone1Controller = TextEditingController(
      text: state.customerDetails.customer.phone1,
    );
    phone2Controller = TextEditingController(
      text: state.customerDetails.customer.phone2,
    );
    addressController = TextEditingController(
      text: state.customerDetails.customer.address,
    );
  }

  void init(String customerUuid) async {
    safeEmit(
      state.copyWith(status: StateStatus.loading, customerUuid: customerUuid),
    );
    await Future.wait([_getCustomerDetails(), _getAllTransactions()]);
  }

  void changeTapIndex(int index) {
    if (index != state.currentTapIndex) {
      switch (index) {
        case 0:
          safeEmit(state.copyWith(currentTapIndex: 0));
          _getAllTransactions();
          break;
        default:
          safeEmit(state.copyWith(currentTapIndex: 1));
          _getCustomerInvoices();
      }
    }
  }

  Future<void> _getCustomerDetails() async {
    safeEmit(state.copyWith(status: StateStatus.loading));
    final result = await _getCustomerDetailsUseCase.call(state.customerUuid);
    result.fold(
      (failure) {
        safeEmit(state.copyWith(status: StateStatus.failure));
      },
      (customerDetails) {
        safeEmit(
          state.copyWith(
            status: StateStatus.success,
            customerDetails: customerDetails,
          ),
        );
      },
    );
  }

  Future<void> deleteCustomer(String uuid, BuildContext context) async {
    safeEmit(state.copyWith(status: StateStatus.loading));
    final result = await _deleteCustomerUseCase(uuid);
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

  Future<void> _getAllTransactions({bool forceRefresh = false}) async {
    if (!forceRefresh && state.transactionsStatus == StateStatus.success) {
      return;
    }
    safeEmit(state.copyWith(transactionsStatus: StateStatus.loading));
    final result = await _getAllUserTransactionsUseCase.call(
      type: UserType.customer,
      uuid: state.customerUuid,
    );
    result.fold(
      (failure) {
        safeEmit(state.copyWith(transactionsStatus: StateStatus.failure));
      },
      (transactions) {
        safeEmit(
          state.copyWith(
            transactionsStatus: StateStatus.success,
            transactions: transactions,
          ),
        );
      },
    );
  }

  Future<void> _getCustomerInvoices({bool forceRefresh = false}) async {
    if (!forceRefresh && state.invoicesStatus == StateStatus.success) {
      return;
    }
    safeEmit(state.copyWith(invoicesStatus: StateStatus.loading));
    final result = await _getCustomerInvoicesUsecase.call(state.customerUuid);
    result.fold(
      (failure) {
        safeEmit(state.copyWith(invoicesStatus: StateStatus.failure));
      },
      (invoices) {
        safeEmit(
          state.copyWith(
            invoicesStatus: StateStatus.success,
            invoices: invoices,
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
    final result = await _updateCustomerUseCase(
      CustomerModel(
        uuid: state.customerUuid,
        name: nameController.text,
        phone1: phone1Controller.text,
        phone2: phone2Controller.text,
        address: addressController.text,
        receivableAmount: state.customerDetails.customer.receivableAmount,
        payableAmount: state.customerDetails.customer.payableAmount,
        id: state.customerDetails.customer.id,
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
          msg: LocaleKeys.customerUpdatedSuccessfully,
          color: AppColors.successColor,
        );
        AppNavigator.pop();
        refresh();
      },
    );
  }

  void refresh() async {
    safeEmit(
      state.copyWith(
        status: StateStatus.initial,
        transactionsStatus: StateStatus.initial,
        invoicesStatus: StateStatus.initial,
        currentTapIndex: 0,
        transactions: [],
        invoices: [],
        errMessage: '',
      ),
    );
    await Future.wait([
      _getCustomerDetails(),
      _getAllTransactions(forceRefresh: true),
    ]);
  }
}
