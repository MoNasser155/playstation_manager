import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/utils/navigator_helper.dart';

import '../../../../../../core/enums/state_status.dart';
import '../../../../../../core/shared/cubits/base_cubit_emiter.dart';
import '../../../../../../core/shared/di.dart';
import '../../../../../../core/widgets/custom_snack_bar.dart';
import '../../../data/models/customer_model.dart';
import '../../../domain/usecases/delete_customer_usecase.dart';
import '../../../domain/usecases/get_all_customers_usecase.dart';
import '../../../domain/usecases/update_customer_usecase.dart';

part 'customer_state.dart';

class CustomersCubit extends BaseCubit<CustomersState> {
  CustomersCubit() : super(CustomersState.initial());

  static CustomersCubit get(context) => BlocProvider.of(context);

  final _getAllCustomersUseCase = sl<GetAllCustomersUseCase>();
  final _deleteCustomerUseCase = sl<DeleteCustomerUseCase>();
  final _updateCustomerUseCase = sl<UpdateCustomerUseCase>();

  final searchController = TextEditingController();

  Future<void> getAllCustomers() async {
    safeEmit(state.copyWith(status: StateStatus.loading));
    final result = await _getAllCustomersUseCase();
    result.fold(
      (failure) {
        safeEmit(
          state.copyWith(
            status: StateStatus.failure,
            errMessage: failure.message,
          ),
        );
      },
      (customers) {
        safeEmit(
          state.copyWith(status: StateStatus.success, customers: customers),
        );
      },
    );
  }

  Future<void> updateCustomer(CustomerModel customer) async {
    safeEmit(state.copyWith(status: StateStatus.loading));
    final result = await _updateCustomerUseCase(customer);
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
        getAllCustomers();
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
        getAllCustomers();
        AppNavigator.pop(result: true);
      },
    );
  }

  void refresh() {
    getAllCustomers();
  }

  void searchOnCustomers() {
    if (searchController.text.isEmpty) {
      safeEmit(state.copyWith(filteredCustomers: []));
    } else {
      final filteredCustomers =
          state.customers
              .where(
                (customer) => customer.name.toLowerCase().contains(
                  searchController.text.toLowerCase(),
                ),
              )
              .toList();
      safeEmit(state.copyWith(filteredCustomers: filteredCustomers));
    }
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}
