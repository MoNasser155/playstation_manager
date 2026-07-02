part of 'global_theming_cubit.dart';

class GlobalThemingState extends Equatable {
  final ThemeMode themeMode;

  const GlobalThemingState({required this.themeMode });

  factory GlobalThemingState.initial() =>
      const GlobalThemingState(themeMode: ThemeMode.light);

  GlobalThemingState copyWith({ThemeMode? themeMode}) {
    return GlobalThemingState(themeMode: themeMode ?? this.themeMode);
  }

  @override
  List<Object> get props => [themeMode];
}
