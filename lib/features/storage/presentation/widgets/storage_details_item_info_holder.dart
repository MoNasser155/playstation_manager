import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/extentions/media_query_extenstions.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_sliver_padding.dart';
import '../../../../core/widgets/image_previewer.dart';
import '../cubits/storage_item_details_cubit/storage_item_details_cubit.dart';
import 'add_storage_item/custom_add_new_storage_item.dart';

class StorageDetailsItemInfoHolder extends StatelessWidget {
  const StorageDetailsItemInfoHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSliverPadding(
      child: Container(
        padding: EdgeInsets.all(AppPadding.pf12),
        constraints: BoxConstraints(maxHeight: 300),
        decoration: BoxDecoration(
          color: context.primaryContainer,
          borderRadius: BorderRadius.circular(AppRadius.r16),
        ),
        child: BlocBuilder<StorageItemDetailsCubit, StorageItemDetailsState>(
          buildWhen: (previous, current) {
            return previous.status != current.status ||
                previous.item != current.item;
          },
          builder: (context, state) {
            final cubit = StorageItemDetailsCubit.get(context);
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          LocaleKeys.itemDetails,
                          style: context.textTheme.displayLarge!.copyWith(
                            color: context.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      gapHFix(20),
                      _CustomRoeDetails(
                        title: LocaleKeys.name,
                        value: state.item.item.itemName,
                      ),
                      gapHFix(12),
                      Row(
                        children: [
                          Expanded(
                            child: _CustomRoeDetails(
                              title: LocaleKeys.quantity,
                              value: state.item.item.quantity.toStringAsFixed(
                                2,
                              ),
                            ),
                          ),

                          Expanded(
                            child: _CustomRoeDetails(
                              title: LocaleKeys.unit,
                              value: state.item.item.type.localizedName,
                            ),
                          ),
                        ],
                      ),
                      gapHFix(12),
                      _CustomRoeDetails(
                        title: LocaleKeys.buyPrice,
                        value:
                            '${state.item.item.buyPrice.toStringAsFixed(2)} ${LocaleKeys.egp}',
                      ),
                      gapHFix(12),
                      _CustomRoeDetails(
                        title: LocaleKeys.sellPrice,
                        value:
                            '${state.item.item.sellPrice.toStringAsFixed(2)} ${LocaleKeys.egp}',
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(
                          left: context.isRtl ? AppPadding.pf20 : 0,
                          right: !context.isRtl ? AppPadding.pf20 : 0,
                        ),
                        child: CustomButton(
                          onTap: () async {
                            final result = await showDialog(
                              context: context,
                              builder: (_) {
                                return AddStorageItemProvider(
                                  item: state.item.item,
                                );
                              },
                            );
                            if (result != null) {
                              cubit.refresh();
                            }
                          },
                          title: LocaleKeys.addToItem,
                        ),
                      ),
                    ],
                  ),
                ),
                ImagePreviewer(
                  imagePath: state.item.item.itemImage,
                  heroTag: state.itemUuid,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.r8),
                      border: Border.all(color: context.colorScheme.primary),
                    ),
                    width: context.width * 0.28,
                    height: context.width * 0.28,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.r8),
                        child: Image.file(
                          File(state.item.item.itemImage),
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Center(
                                child: Icon(
                                  Icons.image_not_supported_rounded,
                                  size: context.width * 0.1,
                                ),
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CustomRoeDetails extends StatelessWidget {
  const _CustomRoeDetails({required this.title, required this.value});
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$title: ',
          style: context.textTheme.displayLarge!.copyWith(
            color: context.colorScheme.secondaryFixed,
          ),
        ),
        gapWFix(8),
        Expanded(
          child: Text(value, style: context.textTheme.displayLarge!.copyWith()),
        ),
      ],
    );
  }
}
