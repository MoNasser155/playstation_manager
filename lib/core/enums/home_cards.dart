import 'package:flutter/material.dart';
import 'package:local_erp_system/core/extentions/theme_extensions.dart';
import 'package:local_erp_system/features/storage/presentation/widgets/add_storage_item/custom_add_new_storage_item.dart';
import 'package:local_erp_system/features/transactions/presentation/widgets/custom_transaction/custom_add_transaction.dart';

import '../../features/home/presentation/screens/settings_screen.dart';
import '../../features/home/presentation/widgets/custom_add_new_user.dart';
import '../../features/main_view/presentation/cubits/main_view_cubit/main_view_cubit.dart';
import '../languages/local_keys.g.dart';

enum HomeCards {
  addUser,
  addStorageItem,
  addTransaction,
  addInvoice,
  viewReports,
  settings;

  String get localizedName {
    switch (this) {
      case HomeCards.addUser:
        return LocaleKeys.addUser;
      case HomeCards.addStorageItem:
        return LocaleKeys.addStorageItem;
      case HomeCards.addTransaction:
        return LocaleKeys.addTransaction;
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
      case HomeCards.addUser:
        return Icon(
          Icons.person_add,
          color: context.colorScheme.onPrimary,
          size: 32,
        );
      case HomeCards.addStorageItem:
        return Icon(
          Icons.inventory,
          color: context.colorScheme.onPrimary,
          size: 32,
        );
      case HomeCards.addTransaction:
        return Icon(
          Icons.request_quote,
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
      case HomeCards.addUser:
        showDialog(context: context, builder: (_) => AddNewUserProvider());
        break;
      case HomeCards.addStorageItem:
        showDialog(context: context, builder: (_) => AddStorageItemProvider());
        break;
      case HomeCards.addTransaction:
        showDialog(
          context: context,
          builder: (_) => CustomAddTransactionProvider(),
        );
        break;
      case HomeCards.addInvoice:
        cubit.setSelectedTap(1);
        break;
      case HomeCards.viewReports:
        cubit.setSelectedTap(5);
        break;
      case HomeCards.settings:
        cubit.setCustomizedView(SettingsScreen());
        break;
    }
  }
}
