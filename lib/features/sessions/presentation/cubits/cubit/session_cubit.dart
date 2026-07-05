import 'dart:async';

import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/enums/device_status.dart';
import '../../../../../core/enums/play_type.dart';
import '../../../../../core/enums/state_status.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/languages/local_keys.g.dart';
import '../../../../../core/shared/cubits/base_cubit_emiter.dart';
import '../../../../../core/shared/di.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/custom_snack_bar.dart';
import '../../../../devices/data/models/device_model.dart';
import '../../../../devices/domain/usecases/get_all_devices_usecase.dart';
import '../../../../storage/data/models/storage_model.dart';
import '../../../data/models/get_session_models.dart';
import '../../../data/models/session_model.dart';
import '../../../domain/usecases/create_session_usecase.dart';
import '../../../domain/usecases/end_device_session_usecase.dart';
import '../../../domain/usecases/get_active_session_for_device_usecase.dart';
import '../../../domain/usecases/get_all_session_models_usecase.dart';
import '../../../domain/usecases/get_all_sessions_usecase.dart';
import '../../../domain/usecases/start_device_session_usecase.dart';
import '../../../domain/usecases/update_session_items_usecase.dart';

part 'session_state.dart';

class SessionCubit extends BaseCubit<SessionState> {
  SessionCubit() : super(SessionState.initial()) {
    setControllersValue();
  }

  static SessionCubit get(context) => BlocProvider.of<SessionCubit>(context);

  final _getAllSessionModelsUsecase = sl<GetAllSessionModelsUseCase>();
  final _createSessionUseCase = sl<CreateSessionUseCase>();
  final _getAllDevicesUseCase = sl<GetAllDevicesUseCase>();
  final _getAllSessionsUseCase = sl<GetAllSessionsUseCase>();
  final _getActiveSessionForDeviceUseCase =
      sl<GetActiveSessionForDeviceUseCase>();
  final _startDeviceSessionUseCase = sl<StartDeviceSessionUseCase>();
  final _updateSessionItemsUseCase = sl<UpdateSessionItemsUseCase>();
  final _endDeviceSessionUseCase = sl<EndDeviceSessionUseCase>();

  final sellPriceController = TextEditingController(text: '0');
  final quantityController = TextEditingController(text: '0');

  Timer? _sessionTimer;

  void setControllersValue() {
    sellPriceController.text =
        state.selectedStorageItem?.sellPrice.toStringAsFixed(2) ?? '';
    quantityController.text =
        state.selectedStorageItem?.quantity.toStringAsFixed(2) ?? '';
  }

  init(BuildContext context, {DeviceModel? device}) {
    safeEmit(state.copyWith(status: StateStatus.loading));

    _getAllSessionModels(context);
    _getAllDevices();
    if (device != null) {
      selectDevice(device);
    }
  }

  void refresh(BuildContext context) {
    _resetSession(context);
  }

  void changeCurrentTapIndex(int index) {
    if (index != state.currentTapIndex) {
      safeEmit(state.copyWith(currentTapIndex: index));
      if (index == 1) {
        loadSessionsList();
      }
    }
  }

  /// Called when the user taps the "Sessions" tab.
  Future<void> loadSessionsList() async {
    safeEmit(state.copyWith(sessionsListStatus: StateStatus.loading));
    final result = await _getAllSessionsUseCase();
    result.fold(
      (_) {
        safeEmit(state.copyWith(sessionsListStatus: StateStatus.failure));
      },
      (sessions) {
        safeEmit(
          state.copyWith(
            sessionList: sessions,
            sessionsListStatus: StateStatus.success,
          ),
        );
      },
    );
  }

  Future<void> _getAllSessionModels(BuildContext context) async {
    safeEmit(state.copyWith(status: StateStatus.loading));
    final result = await _getAllSessionModelsUsecase();
    result.fold(
      (failure) {
        CustomSnackBar.top(context: context, msg: failure.message);
        safeEmit(state.copyWith(status: StateStatus.failure));
      },
      (sessionModels) {
        if (sessionModels.warnings.isNotEmpty) {
          for (AppException warning in sessionModels.warnings) {
            CustomSnackBar.top(context: context, msg: warning.messageKey);
          }
        }
        safeEmit(
          state.copyWith(
            status: StateStatus.success,
            sessionModels: sessionModels,
          ),
        );
      },
    );
  }

  Future<void> _getAllDevices() async {
    final result = await _getAllDevicesUseCase();
    result.fold((_) {}, (devicesList) {
      safeEmit(state.copyWith(devices: devicesList));
    });
  }

  Future<void> selectDevice(DeviceModel? device) async {
    _sessionTimer?.cancel();
    if (device == null) {
      safeEmit(
        state.copyWith(
          clearSelectedDevice: true,
          clearActiveSession: true,
          sessionDuration: Duration.zero,
          sessionCost: 0.0,
          isSessionActive: false,
          sessionItems: [],
          totalSession: 0.0,
          sessionUuid: const Uuid().v4(),
          playType: PlayType.twoPlayers,
          clearSessionEndTime: true,
          isEndingSession: false,
        ),
      );
      return;
    }

    final result = await _getActiveSessionForDeviceUseCase(device.id!);
    result.fold(
      (failure) {
        safeEmit(
          state.copyWith(
            selectedDevice: device,
            clearActiveSession: true,
            sessionDuration: Duration.zero,
            sessionCost: 0.0,
            isSessionActive: false,
            sessionItems: [],
            totalSession: 0.0,
            sessionUuid: const Uuid().v4(),
            playType: PlayType.twoPlayers,
            clearSessionEndTime: true,
            isEndingSession: false,
          ),
        );
      },
      (activeSession) {
        if (activeSession != null) {
          final items = activeSession.items.toList();
          final start = activeSession.sessionStartDate ?? clock.now();
          final duration = clock.now().difference(start);
          final cost = (duration.inSeconds / 3600.0) * activeSession.hourlyRate;
          final itemsTotal = items.fold<double>(
            0.0,
            (s, e) => s + e.totalItemPrice,
          );
          final restoredPlayType = PlayType.values[activeSession.playTypeIndex];

          safeEmit(
            state.copyWith(
              selectedDevice: device,
              activeSession: activeSession,
              sessionDuration: duration,
              sessionCost: cost,
              isSessionActive: true,
              sessionItems: items,
              sessionUuid: activeSession.uuid,
              totalSession: itemsTotal,
              playType: restoredPlayType,
              clearSessionEndTime: true,
              isEndingSession: false,
            ),
          );

          _startSessionTimer();
        } else {
          safeEmit(
            state.copyWith(
              selectedDevice: device,
              clearActiveSession: true,
              sessionDuration: Duration.zero,
              sessionCost: 0.0,
              isSessionActive: false,
              sessionItems: [],
              totalSession: 0.0,
              sessionUuid: const Uuid().v4(),
              playType: PlayType.twoPlayers,
              clearSessionEndTime: true,
              isEndingSession: false,
            ),
          );
        }
      },
    );
  }

  void changePlayType(PlayType type) {
    if (state.isSessionActive) return;
    safeEmit(state.copyWith(playType: type));
  }

  Future<void> startSession(BuildContext context) async {
    final device = state.selectedDevice;
    if (device == null || device.status != DeviceStatus.available) return;

    final hourlyRate =
        state.playType == PlayType.twoPlayers
            ? device.hourlyRate
            : device.multiPlayerHourlyRate;

    final newSession = SessionModel.create(
      uuid: const Uuid().v4(),
      totalSession: 0.0,
      sessionDate: clock.now(),
      isSession: true,
      sessionStartDate: clock.now(),
      hourlyRate: hourlyRate,
      playType: state.playType,
    );
    newSession.device.target = device;

    final result = await _startDeviceSessionUseCase(
      session: newSession,
      device: device,
    );

    result.fold(
      (failure) {
        if (context.mounted) {
          CustomSnackBar.top(context: context, msg: failure.message);
        }
      },
      (id) async {
        final updatedDevice = device.copyWith(status: DeviceStatus.reserved);
        await _getAllDevices();
        await selectDevice(updatedDevice);

        if (context.mounted) {
          CustomSnackBar.top(
            context: context,
            msg: LocaleKeys.sessionStarted,
            color: Colors.green,
          );
        }
      },
    );
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.isSessionActive &&
          state.activeSession != null &&
          !state.isEndingSession) {
        final start = state.activeSession!.sessionStartDate ?? clock.now();
        final duration = clock.now().difference(start);
        final cost =
            (duration.inSeconds / 3600.0) * state.activeSession!.hourlyRate;
        final itemsTotal = state.sessionItems.fold<double>(
          0.0,
          (s, e) => s + e.totalItemPrice,
        );

        safeEmit(
          state.copyWith(
            sessionDuration: duration,
            sessionCost: cost,
            totalSession: itemsTotal,
          ),
        );
      } else if (state.isEndingSession) {
        // Timer paused while dialog is showing
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _persistActiveSessionItems() async {
    if (state.isSessionActive && state.activeSession != null) {
      await _updateSessionItemsUseCase(
        sessionUuid: state.activeSession!.uuid,
        items: state.sessionItems,
      );
    }
  }

  Future<void> endSession(BuildContext context) async {
    if (!state.isSessionActive || state.activeSession == null) return;
    final device = state.selectedDevice;
    if (device == null) return;

    _sessionTimer?.cancel();
    safeEmit(
      state.copyWith(isEndingSession: true, sessionEndTime: clock.now()),
    );
  }

  void cancelEndSession() {
    safeEmit(state.copyWith(isEndingSession: false, clearSessionEndTime: true));
    _startSessionTimer();
  }

  Future<void> confirmEndSession(BuildContext context) async {
    if (!state.isSessionActive || state.activeSession == null) return;
    final device = state.selectedDevice;
    if (device == null) return;

    safeEmit(state.copyWith(status: StateStatus.loading));

    final activeSessionData = state.activeSession!;
    final itemsTotal = state.sessionItems.fold<double>(
      0.0,
      (s, e) => s + e.totalItemPrice,
    );
    final total = state.roundedSessionCost + itemsTotal;

    final completedSession = SessionModel(
      id: activeSessionData.id,
      uuid: activeSessionData.uuid,
      totalSession: total,
      sessionDate: clock.now(),
      isSession: false,
      sessionStartDate: activeSessionData.sessionStartDate,
      hourlyRate: activeSessionData.hourlyRate,
      playTypeIndex: activeSessionData.playTypeIndex,
    );
    completedSession.device.target = device;
    completedSession.items.addAll(state.sessionItems);

    final result = await _endDeviceSessionUseCase(
      completedSession: completedSession,
      device: device,
    );

    result.fold(
      (failure) {
        safeEmit(state.copyWith(status: StateStatus.failure));
        if (context.mounted) {
          CustomSnackBar.top(context: context, msg: failure.message);
        }
      },
      (_) async {
        if (context.mounted) {
          CustomSnackBar.top(
            context: context,
            msg: LocaleKeys.sessionEnded,
            color: Colors.green,
          );
        }

        await _getAllDevices();
        await selectDevice(null);
      },
    );
  }

  void selectItem(StorageModel? item) {
    if (item == null || item == state.selectedStorageItem) return;
    sellPriceController.text = item.sellPrice.toStringAsFixed(2);
    double qty = double.tryParse(quantityController.text.trim()) ?? 0;
    if (qty > item.quantity) {
      qty = item.quantity;
      quantityController.text =
          qty % 1 == 0 ? qty.toInt().toString() : qty.toString();
    }
    safeEmit(
      state.copyWith(
        selectedStorageItem: item,
        currentInputTotal: item.sellPrice * qty,
      ),
    );
  }

  void updateInputTotal([BuildContext? context]) {
    final price = double.tryParse(sellPriceController.text.trim()) ?? 0;
    double qty = double.tryParse(quantityController.text.trim()) ?? 0;

    if (state.selectedStorageItem != null) {
      final maxQty = state.selectedStorageItem!.quantity;
      if (qty > maxQty) {
        qty = maxQty;
        quantityController.text = qty.toStringAsFixed(2);
        quantityController.selection = TextSelection.fromPosition(
          TextPosition(offset: quantityController.text.length),
        );
        if (context != null && context.mounted) {
          CustomSnackBar.top(
            context: context,
            msg: LocaleKeys.quantityLimitExceeded,
          );
        }
      }
    }

    safeEmit(state.copyWith(currentInputTotal: price * qty));
  }

  void addSessionItem() {
    final currentSelectedItem = state.selectedStorageItem;
    if (currentSelectedItem == null || state.currentInputTotal <= 0) return;
    final price = double.tryParse(sellPriceController.text.trim()) ?? 0;
    double qty = double.tryParse(quantityController.text.trim()) ?? 0;
    if (price <= 0 || qty <= 0) return;
    if (qty > currentSelectedItem.quantity) {
      qty = currentSelectedItem.quantity;
      quantityController.text = qty.toStringAsFixed(2);
    }

    List<SessionItem> updated = List<SessionItem>.from(state.sessionItems);
    final existingIndex = updated.indexWhere(
      (item) => item.storageItem.target?.uuid == currentSelectedItem.uuid,
    );

    if (existingIndex != -1) {
      final existing = updated[existingIndex];
      final newQty =
          (existing.quantity + qty)
              .clamp(0, currentSelectedItem.quantity)
              .toDouble();

      final updatedItem = SessionItem(
        sellPrice: price,
        quantity: newQty,
        totalItemPrice: price * newQty,
      )..storageItem.target = existing.storageItem.target;

      updated[existingIndex] = updatedItem;
    } else {
      final newItem = SessionItem(
        sellPrice: price,
        quantity: qty,
        totalItemPrice: price * qty,
      )..storageItem.target = currentSelectedItem;

      updated.add(newItem);
    }

    final total = updated.fold<double>(0, (sum, e) => sum + e.totalItemPrice);
    final finalTotal = total;

    sellPriceController.clear();
    quantityController.clear();

    safeEmit(
      state.copyWith(
        sessionItems: updated,
        totalSession: finalTotal,
        currentInputTotal: 0,
        clearSelectedStorageItem: true,
      ),
    );

    _persistActiveSessionItems();
  }

  void removeSessionItem(int index) {
    final updated = List<SessionItem>.from(state.sessionItems)..removeAt(index);
    final total = updated.fold<double>(0, (sum, e) => sum + e.totalItemPrice);
    final finalTotal = total;

    safeEmit(state.copyWith(sessionItems: updated, totalSession: finalTotal));
    _persistActiveSessionItems();
  }

  Future<void> saveSession(BuildContext context) async {
    if (!state.canSaveSession) return;

    final session = SessionModel.create(
      uuid: state.sessionUuid,
      totalSession: state.totalSession,
      sessionDate: clock.now(),
    );

    // Link items
    session.items.addAll(state.sessionItems);

    safeEmit(state.copyWith(status: StateStatus.loading));

    final result = await _createSessionUseCase(session);
    result.fold(
      (failure) {
        CustomSnackBar.top(context: context, msg: failure.message);
        safeEmit(state.copyWith(status: StateStatus.failure));
      },
      (_) {
        CustomSnackBar.top(
          context: context,
          msg: LocaleKeys.sessionSaved,
          color: AppColors.successColor,
        );
        _resetSession(context);
      },
    );
  }

  void _resetSession(BuildContext context) {
    sellPriceController.clear();
    quantityController.clear();
    _getAllSessionModels(context);
    _getAllDevices();

    safeEmit(
      SessionState.initial().copyWith(
        sessionModels: state.sessionModels,
        devices: state.devices,
        status: StateStatus.success,
      ),
    );
  }

  @override
  Future<void> close() {
    _sessionTimer?.cancel();
    sellPriceController.dispose();
    quantityController.dispose();
    return super.close();
  }
}
