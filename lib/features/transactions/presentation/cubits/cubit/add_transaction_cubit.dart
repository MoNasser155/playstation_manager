import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/enums/state_status.dart';
import '../../../../../core/enums/transaction_type.dart';
import '../../../../../core/enums/user_type.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/shared/cubits/base_cubit_emiter.dart';
import '../../../../../core/shared/di.dart';
import '../../../../../core/utils/navigator_helper.dart';
import '../../../../../core/widgets/custom_snack_bar.dart';
import '../../../../customers/data/models/customer_model.dart';
import '../../../../customers/domain/usecases/get_all_customers_usecase.dart';
import '../../../../suppliers/data/models/supplier_model.dart';
import '../../../../suppliers/domain/usecases/get_all_suppliers_usecase.dart';
import '../../../data/models/transaction_model.dart';
import '../../../domain/usecases/create_transaction_usecase.dart';

part 'add_transaction_state.dart';

class AddTransactionCubit extends BaseCubit<AddTransactionState> {
  AddTransactionCubit() : super(AddTransactionState.initial());

  static AddTransactionCubit get(context) => BlocProvider.of(context);

  final _createTransactionUsecase = sl<CreateTransactionUseCase>();
  final _getAllSuppliersUsecase = sl<GetAllSuppliersUseCase>();
  final _getAllCustomersUsecase = sl<GetAllCustomersUseCase>();

  final TextEditingController notesController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void init({CustomerModel? customer, SupplierModel? supplier}) {
    safeEmit(
      state.copyWith(
        customer: customer,
        supplier: supplier,
        userType: customer != null ? UserType.customer : UserType.supplier,
      ),
    );
  }

  void customInit() {
    safeEmit(state.copyWith(status: StateStatus.loading));
    _getAllCustomers();
  }

  void changeTapIndex(int index) {
    if (index != state.tapIndex) {
      switch (index) {
        case 0:
          safeEmit(state.copyWith(userType: UserType.customer, tapIndex: 0));
          _getAllCustomers();
          break;
        case 1:
          safeEmit(state.copyWith(userType: UserType.supplier, tapIndex: 1));
          _getAllSuppliers();
          break;
        default:
      }
    }
  }

  Future<void> _getAllSuppliers() async {
    if (state.suppliers.isNotEmpty && state.supplierStatus.isSuccess) return;
    final result = await _getAllSuppliersUsecase();
    result.fold(
      (failure) {
        safeEmit(
          state.copyWith(
            supplierStatus: StateStatus.failure,
            errMessage: failure.message,
          ),
        );
      },
      (suppliers) {
        safeEmit(
          state.copyWith(
            supplierStatus: StateStatus.success,
            suppliers: suppliers,
          ),
        );
      },
    );
  }

  void changeSelectedCustomer(CustomerModel? customer) {
    if (customer?.uuid == state.customer?.uuid) return;
    safeEmit(state.copyWith(customer: customer));
  }

  void changeSelectedSupplier(SupplierModel? supplier) {
    if (supplier?.uuid == state.supplier?.uuid) return;
    safeEmit(state.copyWith(supplier: supplier));
  }

  Future<void> _getAllCustomers() async {
    if (state.customers.isNotEmpty && state.customerStatus.isSuccess) return;

    safeEmit(state.copyWith(customerStatus: StateStatus.loading));
    final result = await _getAllCustomersUsecase();
    result.fold(
      (failure) {
        safeEmit(
          state.copyWith(
            customerStatus: StateStatus.failure,
            errMessage: failure.message,
          ),
        );
      },
      (customers) {
        safeEmit(
          state.copyWith(
            customerStatus: StateStatus.success,
            customers: customers,
          ),
        );
      },
    );
  }

  TransactionModel _getTransactionModel() {
    final userUuid =
        state.userType.isCustomer
            ? state.customer?.uuid ?? ""
            : state.supplier?.uuid ?? "";
    final TransactionType type =
        state.userType.isCustomer
            ? TransactionType.customerPayment
            : TransactionType.supplierPayment;
    final String notes =
        notesController.text.isEmpty
            ? state.userType.isCustomer
                ? 'دفعة العميل: ${state.customer?.name} _|_ المبلغ: ${double.tryParse(amountController.text) ?? 0}'
                : 'دفعة المورد: ${state.supplier?.name} _|_ المبلغ: ${double.tryParse(amountController.text) ?? 0}'
            : notesController.text;
    return TransactionModel.create(
      uuid: const Uuid().v4(),
      userUuid: userUuid,
      notes: notes,
      paymentAmount: double.tryParse(amountController.text) ?? 0,
      transactionType: type,
      userType: state.userType,
      createdAt: DateTime.now(),
    );
  }

  Future<void> createTransaction(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    if (state.customer == null && state.supplier == null) {
      CustomSnackBar.top(
        context: context,
        msg:
            state.userType.isCustomer
                ? LocaleKeys.pleaseSelectCustomer
                : LocaleKeys.pleaseSelectSupplier,
      );
      return;
    }
    safeEmit(state.copyWith(status: StateStatus.loading));
    final result = await _createTransactionUsecase.call(_getTransactionModel());
    result.fold(
      (l) {
        safeEmit(
          state.copyWith(status: StateStatus.failure, errMessage: l.message),
        );
      },
      (r) {
        safeEmit(state.copyWith(status: StateStatus.success));
        AppNavigator.pop(result: true);
      },
    );
  }

  @override
  Future<void> close() {
    notesController.dispose();
    amountController.dispose();
    formKey.currentState?.reset();
    return super.close();
  }
}
