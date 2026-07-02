import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../core/enums/state_status.dart';
import '../../../../../../core/shared/cubits/base_cubit_emiter.dart';
import '../../../../../../core/shared/di.dart';
import '../../../../../../core/utils/navigator_helper.dart';
import '../../../../../core/enums/user_type.dart';
import '../../../../customers/data/models/customer_model.dart';
import '../../../../customers/domain/usecases/add_customer_usecase.dart';

part 'add_user_state.dart';

class AddUserCubit extends BaseCubit<AddUserState> {
  AddUserCubit() : super(AddUserState.initial());

  static AddUserCubit get(context) => BlocProvider.of(context);

  final _addCustomerUseCase = sl<AddCustomerUseCase>();

  final nameController = TextEditingController();
  final phone1Controller = TextEditingController();
  final phone2Controller = TextEditingController();
  final addressController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();



  CustomerModel _createNewCustomer() {
    return CustomerModel(
      uuid: const Uuid().v4(),
      name: nameController.text,
      phone1: phone1Controller.text,
      phone2: phone2Controller.text,
      address: addressController.text,
      receivableAmount: 0,
      payableAmount: 0,
    );
  }



  Future<void> addUser() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    safeEmit(state.copyWith(status: StateStatus.loading));
    final result = await _addCustomerUseCase(_createNewCustomer());
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
        AppNavigator.pop(result: true);
      },
    );
  }

  @override
  Future<void> close() async {
    formKey.currentState?.reset();
    nameController.dispose();
    phone1Controller.dispose();
    phone2Controller.dispose();
    addressController.dispose();
    await super.close();
  }
}
