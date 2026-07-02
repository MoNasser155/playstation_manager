import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';

import '../../constants/app_values.dart';
import 'custom_radio_button.dart';

class CustomCheckboxFilterWidget<T> extends StatelessWidget {
  const CustomCheckboxFilterWidget({
    super.key,
    required this.title,
    required this.items,
    this.itemsNames,
    this.selectedListItems,
    required this.onChanged,
  });
  final String title;
  final List<T> items;
  final List<String>? itemsNames;
  final List<int>? selectedListItems;
  final void Function(bool?) onChanged;
  @override
  Widget build(BuildContext context) {
    final displayedNames =
        itemsNames ?? items.map((e) => e.toString()).toList();
    return Column(
      spacing: AppSpacing.v8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.bodyLarge!.copyWith(
            color: context.colorScheme.onPrimary,
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 8,
            crossAxisSpacing: AppSpacing.h4,
            mainAxisSpacing: AppSpacing.v4,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Row(
              spacing: AppSpacing.h4,
              children: [
                Checkbox(
                  value:
                      selectedListItems != null
                          ? selectedListItems!.contains(index)
                          : false,
                  onChanged: onChanged,
                  activeColor: context.colorScheme.primary,
                  checkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                ),
                Expanded(
                  child: Text(
                    displayedNames[index],
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: context.colorScheme.secondaryFixed,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class CustomRadioButtonFilterWidget<T> extends StatelessWidget {
  const CustomRadioButtonFilterWidget({
    super.key,
    required this.title,
    required this.items,
    this.itemsNames,
    this.selectedItem,
    required this.onChanged,
  });
  final String title;
  final List<T> items;
  final List<String>? itemsNames;
  final T? selectedItem;
  final void Function(T) onChanged;

  @override
  Widget build(BuildContext context) {
    final displayedNames =
        itemsNames ?? items.map((e) => e.toString()).toList();
    return Column(
      spacing: AppSpacing.v8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.bodyLarge!.copyWith(
            color: context.colorScheme.onPrimary,
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 6.5,
            crossAxisSpacing: AppSpacing.h4,
            mainAxisSpacing: AppSpacing.v8,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => onChanged(items[index]),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.v4),
                child: Row(
                  spacing: AppSpacing.h4,
                  children: [
                    CustomRadioButton(isSelected: selectedItem == items[index]),
                    Expanded(
                      child: Text(
                        displayedNames[index],
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: context.colorScheme.secondaryFixed,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
