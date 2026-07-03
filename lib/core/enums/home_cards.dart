import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';
import 'package:local_erp_system/features/storage/presentation/widgets/add_storage_item/custom_add_new_storage_item.dart';

import '../../features/home/presentation/screens/settings_screen.dart';
import '../../features/main_view/presentation/cubits/main_view_cubit/main_view_cubit.dart';
import '../languages/local_keys.g.dart';

enum HomeCards {
  addStorageItem,
  addInvoice,
  viewReports,
  settings;

  String get localizedName {
    switch (this) {
      case HomeCards.addStorageItem:
        return LocaleKeys.addStorageItem;
      case HomeCards.addInvoice:
        return LocaleKeys.createInvoice;
      case HomeCards.viewReports:
        return LocaleKeys.viewReports;
      case HomeCards.settings:
        return LocaleKeys.settings;
    }
  }

  Widget getIcon(BuildContext context) {
    switch (this) {
      case HomeCards.addStorageItem:
        return Icon(
          Icons.inventory,
          color: context.colorScheme.onPrimary,
          size: 32,
        );
      case HomeCards.addInvoice:
        return Icon(
          Icons.receipt_long,
          color: context.colorScheme.onPrimary,
          size: 32,
        );
      case HomeCards.viewReports:
        return Icon(
          Icons.analytics,
          color: context.colorScheme.onPrimary,
          size: 32,
        );
      case HomeCards.settings:
        return Icon(
          Icons.settings,
          color: context.colorScheme.onPrimary,
          size: 32,
        );
    }
  }

  void function(BuildContext context) {
    final cubit = MainViewCubit.get(context);
    switch (this) {
      case HomeCards.addStorageItem:
        showDialog(context: context, builder: (_) => AddStorageItemProvider());
        break;
      case HomeCards.addInvoice:
        cubit.setSelectedTap(1);
        break;
      case HomeCards.viewReports:
        cubit.setSelectedTap(4); // Shifted from 5 because customers tab was removed (index 2)
        break;
      case HomeCards.settings:
        cubit.setCustomizedView(SettingsScreen());
        break;
    }
  }
}
