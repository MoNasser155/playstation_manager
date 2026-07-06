import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playstation_manager/core/extentions/media_query_extenstions.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../constants/app_values.dart';
import '../languages/local_keys.g.dart';
import '../theme/app_colors.dart';
import '../utils/gaps.dart';
import 'custom_text_field.dart';

class ExpandedDropdown<T> extends StatefulWidget {
  final String hint;
  final List<T> items;
  final String? selectedValue;
  final String Function(T) itemLabelBuilder;
  final String Function(T)? itemSublabelBuilder;
  final ValueChanged<T?>? onChanged;
  final bool isEnabled;
  final int? maxLines;
  final bool isLabeled;
  final bool isLoading;
  final Widget? prefix;
  final bool withSearch;
  final Color? backgroundColor, searchFieldColor;
  final InputDecoration? decoration;

  const ExpandedDropdown({
    super.key,
    required this.hint,
    required this.items,
    required this.itemLabelBuilder,
    this.itemSublabelBuilder,
    this.selectedValue,
    this.onChanged,
    this.isEnabled = true,
    this.maxLines = 1,
    this.isLabeled = true,
    this.isLoading = false,
    this.prefix,
    this.withSearch = false,
    this.backgroundColor,
    this.searchFieldColor,
    this.decoration,
  });

  @override
  State<ExpandedDropdown<T>> createState() => _ExpandedDropdownState<T>();
}

class _ExpandedDropdownState<T> extends State<ExpandedDropdown<T>> {
  final TextEditingController _searchController = TextEditingController();

  bool get _showSearch => widget.withSearch && widget.items.isNotEmpty;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<T>(
      decoration:
          widget.decoration ??
          InputDecoration(
            prefixIcon: widget.prefix,
            fillColor: widget.backgroundColor,
          ),
      isExpanded: true,
      hint:
          widget.isLoading
              ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
              : (widget.selectedValue == null || widget.selectedValue == '')
              ? Text(widget.hint)
              : Text(widget.selectedValue!),
      items:
          widget.items.map((item) {
            final isSelected =
                widget.itemLabelBuilder(item) == widget.selectedValue;
            return DropdownItem<T>(
              value: item,
              intrinsicHeight: true,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: AppPadding.p12,
                  horizontal: AppPadding.p12,
                ),
                width: double.infinity,
                color:
                    isSelected
                        ? context.colorScheme.secondaryFixed.withValues(
                          alpha: 0.1,
                        )
                        : Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child:
                          widget.itemSublabelBuilder == null
                              ? Text(
                                widget.itemLabelBuilder(item),
                                style: context.textTheme.titleLarge,
                                maxLines: widget.maxLines,
                                overflow: TextOverflow.ellipsis,
                              )
                              : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.itemLabelBuilder(item),
                                    style: context.textTheme.titleLarge,
                                    maxLines: widget.maxLines,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  gapHFix(4),
                                  Text(
                                    widget.itemSublabelBuilder!(item),
                                    style: context.textTheme.bodyMedium
                                        ?.copyWith(
                                          color:
                                              context
                                                  .colorScheme
                                                  .secondaryFixed,
                                        ),
                                    maxLines: widget.maxLines,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                    ),
                    isSelected
                        ? Icon(
                          Icons.check_rounded,
                          color: AppColors.successColor,
                        )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            );
          }).toList(),
      onChanged: widget.isEnabled ? widget.onChanged : null,
      iconStyleData: IconStyleData(
        icon: Transform.rotate(
          angle: context.isRtl ? 3.14 * 2.5 : 3.14 * 1.5,
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: context.colorScheme.onPrimary,
            size: 16.sp,
          ),
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: context.height / 2,
        elevation: 8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(AppRadius.r12),
            bottomRight: Radius.circular(AppRadius.r12),
          ),
          color: context.primaryContainer,
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.shadow,
              blurRadius: 12,
              offset: Offset(0, 2),
            ),
          ],
        ),

        offset: const Offset(0, -5),
      ),
      menuItemStyleData: MenuItemStyleData(
        padding: EdgeInsets.zero,
        selectedMenuItemBuilder:
            (context, child) =>
                Container(color: AppColors.successColor, child: child),
      ),
      dropdownSearchData:
          _showSearch
              ? DropdownSearchData<T>(
                searchController: _searchController,
                searchBarWidgetHeight: 56,
                searchBarWidget: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                  child: CustomTextField(
                    fillColor: widget.searchFieldColor,
                    controller: _searchController,
                    hint: LocaleKeys.search,
                    prefix: const Icon(Icons.search_outlined),
                    scrollPhysics: const ClampingScrollPhysics(),
                  ),
                ),
                searchMatchFn: (item, _) {
                  final query = _searchController.text.toLowerCase().trim();
                  if (query.isEmpty) return true;
                  return widget
                      .itemLabelBuilder(item.value as T)
                      .toLowerCase()
                      .contains(query);
                },
              )
              : null,
    );
  }
}
