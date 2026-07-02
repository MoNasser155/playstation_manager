part of 'main_view_cubit.dart';

class MainViewState extends Equatable {
  final MainViewMode mode;
  final DesktopDrawerMode drawerMode;
  final Widget view;
  final Widget drawerView;
  final Widget? customizedView;
  final List<Object>? sendData;
  final int selectedTapIndex;
  final bool isLoading;
  final BackupStatus backupStatus;
  final RestoreStatus restoreStatus;
  final String? backupError;

  const MainViewState({
    required this.mode,
    required this.view,
    required this.drawerView,
    required this.drawerMode,
    required this.selectedTapIndex,
    this.customizedView,
    this.sendData,
    this.isLoading = false,
    required this.backupStatus,
    required this.restoreStatus,
    this.backupError,
  });

  factory MainViewState.initial() {
    return MainViewState(
      mode: MainViewMode.mobile,
      view: Scaffold(),
      drawerView: HomeScreen(),
      drawerMode: DesktopDrawerMode.open,
      selectedTapIndex: 0,
      customizedView: null,
      sendData: null,
      backupError: null,
      backupStatus: BackupStatus.idle,
      restoreStatus: RestoreStatus.idle,
    );
  }

  MainViewState copyWith({
    MainViewMode? mode,
    Widget? view,
    DesktopDrawerMode? drawerMode,
    Widget? drawerView,
    int? selectedTapIndex,
    Widget? Function()? customizedView,
    List<Object>? sendData,
    bool? isLoading,
    BackupStatus? backupStatus,
    RestoreStatus? restoreStatus,
    String? backupError,
  }) {
    return MainViewState(
      mode: mode ?? this.mode,
      view: view ?? this.view,
      drawerView: drawerView ?? this.drawerView,
      drawerMode: drawerMode ?? this.drawerMode,
      selectedTapIndex: selectedTapIndex ?? this.selectedTapIndex,
      customizedView:
          customizedView != null ? customizedView() : this.customizedView,
      sendData: sendData ?? this.sendData,
      isLoading: isLoading ?? this.isLoading,
      backupError: backupError ?? this.backupError,
      backupStatus: backupStatus ?? this.backupStatus,
      restoreStatus: restoreStatus ?? this.restoreStatus,
    );
  }

  @override
  List<Object?> get props => [
    mode,
    view,
    drawerView,
    drawerMode,
    selectedTapIndex,
    customizedView,
    sendData,
    isLoading,
    backupStatus,
    backupError,
    restoreStatus,
  ];
}
