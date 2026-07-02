import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/utils/gaps.dart';
import '../../../main_view/presentation/cubits/main_view_cubit/main_view_cubit.dart';
import '../../data/models/storage_model.dart';
import '../cubits/storage_cubit/storage_cubit.dart';
import '../screens/storage_item_details_screen.dart';
import 'custom_delete_storage_item_dialog.dart';

class StorageItemWidget extends StatelessWidget {
  const StorageItemWidget({super.key, required this.item});

  final StorageModel item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final cubit = MainViewCubit.get(context);
        cubit.setCustomizedView(
          StorageItemDetailsScreen(storageItemUuid: item.uuid),
        );
      },
      child: Container(
        padding: EdgeInsets.all(AppRadius.r12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.r12),
          border: Border.all(
            width: 1.3,
            color:
                item.isLow
                    ? context.colorScheme.error.withValues()
                    : Colors.transparent,
          ),
          color: context.primaryContainer,
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.r8),
                child: Image.file(
                  File(item.itemImage),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder:
                      (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.image_not_supported_rounded,
                          size: 100.sp,
                        ),
                      ),
                ),
              ),
            ),
            gapH(8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.itemName,
                        style: context.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      gapH(4),
                      Text(
                        '${item.quantity} ${item.type.localizedName}',
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: context.colorScheme.secondaryFixed,
                        ),
                      ),
                    ],
                  ),
                ),

                InkWell(
                  onTap: () async {
                    final cubit = StorageCubit.get(context);
                    final result = await showDialog<bool?>(
                      context: context,
                      builder:
                          (_) => CustomDeleteStorageItemDialog(
                            onTap: () {
                              cubit.deleteStorageItem(item.uuid, context);
                            },
                            item: item,
                          ),
                    );
                    if (result == true) {
                      cubit.refresh();
                    }
                  },
                  child: Icon(
                    Icons.delete_rounded,
                    color: context.colorScheme.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
