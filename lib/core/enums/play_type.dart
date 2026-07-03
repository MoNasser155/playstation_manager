import '../languages/local_keys.g.dart';

enum PlayType {
  twoPlayers,
  multiPlayer;

  String get localizedName {
    switch (this) {
      case PlayType.twoPlayers:
        return LocaleKeys.twoPlayers;
      case PlayType.multiPlayer:
        return LocaleKeys.multiPlayer;
    }
  }
}
