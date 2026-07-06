import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/enums/storage_item_type.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/utils/navigator_helper.dart';
import '../../../../core/utils/validations.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/expanded_drop_down.dart';
import '../../../main_view/presentation/cubits/main_view_cubit/main_view_cubit.dart';
import '../cubits/storage_item_details_cubit/storage_item_details_cubit.dart';
import 'custom_delete_storage_item_dialog.dart';

part 'edit_storage_item_dialog.dart';

class StorageDetailsInfoHeader extends StatelessWidget {
  const StorageDetailsInfoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StorageItemDetailsCubit, StorageItemDetailsState>(
      buildWhen: (prev, curr) => curr.status != prev.status,
      builder: (context, state) {
        final storageDetailsCubit = StorageItemDetailsCubit.get(context);
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.pf20,
            vertical: AppPadding.pf12,
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  final cubit = MainViewCubit.get(context);
                  cubit.clearCustomizedView();
                },
                child: Container(
                  padding: EdgeInsets.all(AppPadding.pf8),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: context.colorScheme.onPrimary,
                  ),
                ),
              ),
              gapW(12),
              Expanded(
                child: Text(
                  state.item.item.itemName,
                  style: context.textTheme.displayLarge!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              gapW(12),
              InkWell(
                onTap: () {
                  storageDetailsCubit.setControllers();
                  showDialog(
                    context: context,
                    builder: (_) {
                      return _EditStorageItemDialog(cubit: storageDetailsCubit);
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(AppPadding.pf8),
                  child: Icon(
                    Icons.edit_note_rounded,
                    color: context.colorScheme.onPrimary,
                  ),
                ),
              ),
              gapW(8),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return CustomDeleteStorageItemDialog(
                        item: state.item.item,
                        onTap: () {
                          storageDetailsCubit.deleteStorageItem(
                            state.item.item.uuid,
                            context,
                          );
                          AppNavigator.pop();
                        },
                      );
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(AppPadding.pf8),
                  child: Icon(
                    Icons.delete_rounded,
                    color: context.colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
