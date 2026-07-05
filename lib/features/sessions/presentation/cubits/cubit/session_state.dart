part of 'session_cubit.dart';

class SessionState extends Equatable {
  final StateStatus status;
  final String? errMessage;
  final GetSessionModels sessionModels;
  final StorageModel? selectedStorageItem;
  final String sessionUuid;
  final List<SessionModel> sessionList;
  /// Separate status for the sessions-history tab (loading / success / failure)
  final StateStatus sessionsListStatus;
  final int currentTapIndex;
  final List<SessionItem> sessionItems;
  final double totalSession;
  final double currentInputTotal;

  // Devices & Sessions fields
  final List<DeviceModel> devices;
  final DeviceModel? selectedDevice;
  final SessionModel? activeSession;
  final Duration sessionDuration;
  final double sessionCost;
  final bool isSessionActive;

  // New fields for confirmation dialog & play type
  final PlayType playType;
  final DateTime? sessionEndTime;
  final bool isEndingSession;

  const SessionState({
    required this.status,
    this.errMessage,
    required this.sessionModels,
    this.selectedStorageItem,
    required this.sessionUuid,
    required this.sessionList,
    required this.sessionsListStatus,
    required this.currentTapIndex,
    required this.sessionItems,
    required this.totalSession,
    required this.currentInputTotal,
    required this.devices,
    this.selectedDevice,
    this.activeSession,
    required this.sessionDuration,
    required this.sessionCost,
    required this.isSessionActive,
    required this.playType,
    this.sessionEndTime,
    required this.isEndingSession,
  });

  factory SessionState.initial() {
    return SessionState(
      status: StateStatus.initial,
      sessionModels: GetSessionModels(storageItems: [], warnings: []),
      selectedStorageItem: null,
      sessionUuid: const Uuid().v4(),
      sessionList: [],
      sessionsListStatus: StateStatus.initial,
      currentTapIndex: 0,
      sessionItems: [],
      totalSession: 0,
      currentInputTotal: 0,
      devices: const [],
      selectedDevice: null,
      activeSession: null,
      sessionDuration: Duration.zero,
      sessionCost: 0.0,
      isSessionActive: false,
      playType: PlayType.twoPlayers,
      sessionEndTime: null,
      isEndingSession: false,
    );
  }

  bool get canAddItem => selectedStorageItem != null && currentInputTotal > 0;

  bool get canSaveSession =>
      !isSessionActive && sessionItems.isNotEmpty && totalSession > 0;

  double get roundedSessionCost {
    if (sessionCost <= 0) return 0.0;
    final rounded = sessionCost.round();
    final remainder = rounded % 5;
    if (remainder <= 2) {
      return (rounded - remainder).toDouble();
    } else {
      return (rounded + (5 - remainder)).toDouble();
    }
  }

  SessionState copyWith({
    StateStatus? status,
    String? errMessage,
    GetSessionModels? sessionModels,
    StorageModel? selectedStorageItem,
    bool clearSelectedStorageItem = false,
    String? sessionUuid,
    List<SessionModel>? sessionList,
    StateStatus? sessionsListStatus,
    int? currentTapIndex,
    List<SessionItem>? sessionItems,
    double? totalSession,
    double? currentInputTotal,
    List<DeviceModel>? devices,
    DeviceModel? selectedDevice,
    bool clearSelectedDevice = false,
    SessionModel? activeSession,
    bool clearActiveSession = false,
    Duration? sessionDuration,
    double? sessionCost,
    bool? isSessionActive,
    PlayType? playType,
    DateTime? sessionEndTime,
    bool clearSessionEndTime = false,
    bool? isEndingSession,
  }) {
    return SessionState(
      status: status ?? this.status,
      errMessage: errMessage ?? this.errMessage,
      sessionModels: sessionModels ?? this.sessionModels,
      selectedStorageItem:
          clearSelectedStorageItem
              ? null
              : selectedStorageItem ?? this.selectedStorageItem,
      sessionUuid: sessionUuid ?? this.sessionUuid,
      sessionList: sessionList ?? this.sessionList,
      sessionsListStatus: sessionsListStatus ?? this.sessionsListStatus,
      currentTapIndex: currentTapIndex ?? this.currentTapIndex,
      sessionItems: sessionItems ?? this.sessionItems,
      totalSession: totalSession ?? this.totalSession,
      currentInputTotal: currentInputTotal ?? this.currentInputTotal,
      devices: devices ?? this.devices,
      selectedDevice:
          clearSelectedDevice ? null : selectedDevice ?? this.selectedDevice,
      activeSession:
          clearActiveSession
              ? null
              : activeSession ?? this.activeSession,
      sessionDuration: sessionDuration ?? this.sessionDuration,
      sessionCost: sessionCost ?? this.sessionCost,
      isSessionActive: isSessionActive ?? this.isSessionActive,
      playType: playType ?? this.playType,
      sessionEndTime:
          clearSessionEndTime ? null : sessionEndTime ?? this.sessionEndTime,
      isEndingSession: isEndingSession ?? this.isEndingSession,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errMessage,
    sessionModels,
    selectedStorageItem,
    sessionUuid,
    sessionList,
    sessionsListStatus,
    currentTapIndex,
    sessionItems,
    totalSession,
    currentInputTotal,
    devices,
    selectedDevice,
    activeSession,
    sessionDuration,
    sessionCost,
    isSessionActive,
    playType,
    sessionEndTime,
    isEndingSession,
  ];
}
