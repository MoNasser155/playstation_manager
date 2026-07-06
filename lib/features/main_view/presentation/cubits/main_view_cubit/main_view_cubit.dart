import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playstation_manager/features/devices/data/models/device_model.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/enums/desktop_drawer_mode.dart';
import '../../../../../core/enums/main_view_mode.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/services/backup_service.dart';
import '../../../../../core/shared/cubits/base_cubit_emiter.dart';
import '../../../../devices/presentation/screens/devices_screen.dart';
import '../../../../home/presentation/screens/home_screen.dart';
import '../../../../profit/presentation/screens/profit_screen.dart';
import '../../../../sessions/presentation/screens/session_screen.dart';
import '../../../../storage/presentation/screens/storage_screen.dart';
import '../../../../transactions/presentation/screens/transactions_screen.dart';
import '../../../data/models/taps_model.dart';
import '../../screens/desktop_main_view_screen.dart';
import '../../screens/mobile_main_view_screen.dart';
import '../../screens/tablet_main_view_screen.dart';

part 'main_view_state.dart';

class MainViewCubit extends BaseCubit<MainViewState> {
  MainViewCubit() : super(MainViewState.initial());

  static MainViewCubit get(context) => BlocProvider.of<MainViewCubit>(context);

  List<Widget> get views => [
    MobileMainViewScreen(),
    TabletMainViewScreen(),
    DesktopMainViewScreen(),
  ];

  List<TapsModel> get taps => [
    TapsModel(title: LocaleKeys.home, icon: VectorIcons.home),
    TapsModel(title: LocaleKeys.sessions, icon: VectorIcons.receipt),
    TapsModel(title: LocaleKeys.devices, icon: VectorIcons.gamepad),
    TapsModel(title: LocaleKeys.inventory, icon: VectorIcons.inventory),
    TapsModel(title: LocaleKeys.transactions, icon: VectorIcons.transactions),
    TapsModel(title: LocaleKeys.profit, icon: VectorIcons.profit),
    TapsModel(
      title: LocaleKeys.saveLocalBackup,
      icon: VectorIcons.save,
      onTap: _runCreateBackup,
    ),
    // TapsModel(
    //   title: LocaleKeys.driveBackup,
    //   icon: VectorIcons.driveExport,
    //   onTap: _runDriveBackup, // wire up however you do drive
    // ),
  ];

  List<Widget> drawerViews(List<Object>? data) => [
    HomeScreen(),
    SessionScreen(
      device:
          data?.isNotEmpty == true && data![0] is DeviceModel
              ? data[0] as DeviceModel?
              : null,
    ),
    DevicesScreen(),
    StorageScreen(),
    TransactionsScreen(),
    ProfitScreen(),
  ];

  void updateMode(BoxConstraints constraints) {
    MainViewMode newMode;

    switch (constraints.maxWidth) {
      case < AppConstants.mobileBreakpoint:
        newMode = MainViewMode.mobile;
        break;
      case < AppConstants.tabletBreakpoint:
        newMode = MainViewMode.tablet;
        break;
      default:
        newMode = MainViewMode.desktop;
    }
    if (state.mode != newMode) {
      safeEmit(state.copyWith(mode: newMode, view: views[newMode.index]));
    }
  }

  void toggleDesktopDrawer() {
    DesktopDrawerMode newDrawerMode;
    switch (state.drawerMode) {
      case DesktopDrawerMode.open:
        newDrawerMode = DesktopDrawerMode.shortened;
        break;
      case DesktopDrawerMode.shortened:
        newDrawerMode = DesktopDrawerMode.open;
        break;
    }
    if (state.drawerMode != newDrawerMode) {
      safeEmit(state.copyWith(drawerMode: newDrawerMode));
    }
  }

  void setSelectedTap(int index, {List<Object>? send}) {
    if (state.isLoading) return;

    final tap = taps[index];
    if (tap.onTap != null) {
      tap.onTap!();
      return;
    }
    clearCustomizedView();
    if (state.selectedTapIndex != index) {
      safeEmit(
        state.copyWith(
          selectedTapIndex: index,
          sendData: send,
          drawerView: drawerViews(send)[index],
        ),
      );
    }
  }

  Future<void> _runCreateBackup() async {
    safeEmit(
      state.copyWith(
        backupStatus: BackupStatus.idle,
        restoreStatus: RestoreStatus.idle,
      ),
    );
    if (state.isLoading) return;
    safeEmit(state.copyWith(isLoading: true));
    try {
      final status = await BackupService.createBackup();
      safeEmit(state.copyWith(backupStatus: status));
    } on AppException catch (e) {
      safeEmit(
        state.copyWith(
          backupStatus: BackupStatus.failure,
          backupError: e.messageKey,
        ),
      );
    }
  }

  Future<void> runRestore({
    required String backupPath,
    required BuildContext context,
  }) async {
    safeEmit(
      state.copyWith(
        restoreStatus: RestoreStatus.idle,
        backupStatus: BackupStatus.idle,
      ),
    );

    if (state.isLoading) return;
    safeEmit(
      state.copyWith(isLoading: true, restoreStatus: RestoreStatus.idle),
    );
    try {
      final status = await BackupService().restoreBackup(backupPath);
      safeEmit(state.copyWith(restoreStatus: status));
    } on AppException catch (e) {
      safeEmit(
        state.copyWith(
          restoreStatus: RestoreStatus.failure,
          backupError: e.messageKey,
        ),
      );
    }
  }

  // Future<void> _runDriveBackup() async {}

  void setCustomizedView(Widget view) {
    safeEmit(state.copyWith(customizedView: () => view));
  }

  void clearCustomizedView() {
    if (state.customizedView != null) {
      safeEmit(state.copyWith(customizedView: () => null));
    }
  }
}
