import '../languages/local_keys.g.dart';

extension DateExtensions on DateTime {
  String get toFullFormattedDate {
    List<String> weekdays = [
      LocaleKeys.mon,
      LocaleKeys.tue,
      LocaleKeys.wed,
      LocaleKeys.thu,
      LocaleKeys.fri,
      LocaleKeys.sat,
      LocaleKeys.sun,
    ];

    String dayName = weekdays[weekday - 1];
    String hourName = hour >= 12 ? (hour - 12).toString() : hour.toString();
    String timeAmPm = hour >= 12 ? LocaleKeys.pm : LocaleKeys.am;

    return "$dayName $day/$month/$year ${LocaleKeys.at} $hourName:$minute $timeAmPm";
  }

  String get toFullArabicFormattedDate {
    List<String> weekdays = const [
      "الاثنين",
      "الثلاثاء",
      "الأربعاء",
      "الخميس",
      "الجمعة",
      "السبت",
      "الأحد",
    ];

    String dayName = weekdays[weekday - 1];
    String hourName = hour >= 12 ? (hour - 12).toString() : hour.toString();
    String timeAmPm = hour >= 12 ? "مساءاً" : "صباحاً";

    return "$dayName $day/$month/$year في تمام الساعة  $hourName:$minute $timeAmPm";
  }

  String get shortenFormattedDate {
    String hourName = hour >= 12 ? (hour - 12).toString() : hour.toString();
    String timeAmPm = hour >= 12 ? LocaleKeys.pm : LocaleKeys.am;

    return "$day-$month-$year -- $hourName:$minute $timeAmPm";
  }

  String get shortenFormattedPdfDate {
    String hourName = hour >= 12 ? (hour - 12).toString() : hour.toString();
    return "$day-$month-$year -- $hourName-$minute";
  }

  String get defaultFormattedDate {
    return "$day/$month/$year";
  }
}
