import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/enums/state_status.dart';
import '../../../../../core/shared/cubits/base_cubit_emiter.dart';
import '../../../../../core/shared/di.dart';
import '../../../../../core/utils/navigator_helper.dart';
import '../../../data/models/supplier_model.dart';
import '../../../domain/usecases/add_supplier_usecase.dart';

part 'add_supplier_state.dart';

class AddSupplierCubit extends BaseCubit<AddSupplierState> {
  AddSupplierCubit() : super(AddSupplierState.initial());

  static AddSupplierCubit get(context) => BlocProvider.of(context);

  final _addSupplierUseCase = sl<AddSupplierUseCase>();

  final nameController = TextEditingController();
  final phone1Controller = TextEditingController();
  final phone2Controller = TextEditingController();
  final addressController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> addSupplier() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    final supplier = SupplierModel(
      uuid: const Uuid().v4(),
      name: nameController.text,
      phone1: phone1Controller.text,
      phone2: phone2Controller.text,
      address: addressController.text,
      receivableAmount: 0,
      payableAmount: 0,
    );
    safeEmit(state.copyWith(status: StateStatus.loading));
    final result = await _addSupplierUseCase(supplier);
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
  Future<void> close() {
    nameController.dispose();
    phone1Controller.dispose();
    phone2Controller.dispose();
    addressController.dispose();
    formKey.currentState?.reset();
    return super.close();
  }
}
