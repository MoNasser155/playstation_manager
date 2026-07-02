// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:watcher/watcher.dart';

import '../utils/exceptions.dart';
import '../utils/generate_constants.dart';
import 'models/names.dart';

/// TO run this file, write this command in terminal:
/// "dart generate/strings/main.dart"
void main() async {
  const String filePath = GenerateConstants.langJsonAssetFilePath;
  final File file = File(filePath);

  final FileWatcher watcher = FileWatcher(filePath);
  final String previousContent = file.readAsStringSync();
  watcher.events.listen((WatchEvent event) {
    if (event.type == ChangeType.MODIFY) {
      print('File changed: ${watcher.path}');
      handleFileChange(file, previousContent);
    }
  });

  final Map<String, dynamic> jsonMap = json.decode(previousContent);

  // Generate translations for all supported languages
  final Map<String, dynamic> jsonEnMap = await generateJsonTranslate(
    lang: 'en',
    jsonMap: jsonMap,
  );

  // Generate for all other languages defined in constants
  for (final String lang in GenerateConstants.supportedLanguages) {
    if (lang != 'en') {
      await generateJsonTranslate(lang: lang, jsonMap: jsonMap);
    }
  }

  await generateAppStrings(jsonEnMap);
  print('Watching for changes in: ${watcher.path}');
}

void handleFileChange(File file, String previousContent) async {
  try {
    final String currentContent = file.readAsStringSync();
    final List<String> currentLines = currentContent.split('\n');
    final List<String> previousLines = previousContent.split('\n');

    for (int i = 0; i < currentLines.length; i++) {
      if (i >= previousLines.length || currentLines[i] != previousLines[i]) {
        print('Line ${i + 1} changed');
        print(
          'Previous: ${(i) >= previousLines.length ? 'null' : previousLines[i]}',
        );
        print('Current: ${currentLines[i]}');
        print('------------------------------------------------------');
      }
    }
    previousContent = currentContent;

    final Map<String, dynamic> jsonMap = json.decode(currentContent);
    final Map<String, dynamic> jsonEnMap = await generateJsonTranslate(
      lang: 'en',
      jsonMap: jsonMap,
    );

    // Generate for all other languages
    for (final String lang in GenerateConstants.supportedLanguages) {
      if (lang != 'en') {
        await generateJsonTranslate(lang: lang, jsonMap: jsonMap);
      }
    }

    await generateAppStrings(jsonEnMap);
  } catch (e) {
    print('Unknown Key: $e');
  }
}

/// Extracts the translation for a specific language from the translation string
/// Format: "{en: Home, ar: الرئيسية}" or "{en: Welcome Back, nice to meet you, ar: مرحبا}"
String extractTranslation(String value, String targetLang) {
  // Remove curly braces
  String cleaned = value.trim();
  if (cleaned.startsWith('{') && cleaned.endsWith('}')) {
    cleaned = cleaned.substring(1, cleaned.length - 1);
  }

  // Use regex to match language code followed by colon and capture everything until next language code or end
  // Pattern: lang_code: text (where text continues until we hit another lang_code: or end)
  final RegExp regex = RegExp(r'(\w+)\s*:\s*([^}]+?)(?=,\s*\w+\s*:|$)');
  final Iterable<RegExpMatch> matches = regex.allMatches(cleaned);

  for (final RegExpMatch match in matches) {
    final String? lang = match.group(1);
    final String? text = match.group(2);

    if (lang == targetLang && text != null) {
      return text.trim();
    }
  }

  // If translation not found, return the original value
  return value;
}

Future<Map<String, dynamic>> generateJsonTranslate({
  required String lang,
  required Map<String, dynamic> jsonMap,
}) async {
  final StringBuffer buffer = StringBuffer();

  // Get the file path for the current language
  final String filePath = GenerateConstants.getLanguageFilePath(lang);
  if (filePath.isEmpty) {
    print(
      '${GenerateConstants.redColorCode}Language "$lang" is not supported!${GenerateConstants.resetColorCode}',
    );
    return {};
  }

  final File file = File(filePath);
  buffer.writeln('{');

  int counter = 0;
  jsonMap.forEach((String key, dynamic value) {
    try {
      final Names keyNames = Names.fromString(key);

      String translatedValue = extractTranslation(value.toString(), lang);

      buffer.write('  "${keyNames.snakeCase}": "$translatedValue"');

      if (counter < jsonMap.length - 1) {
        buffer.write(',');
      }
      buffer.writeln();
    } on NamesException {
      final String keyStr = '[$key]';
      const String errorMessage = 'is not valid!';
      print(
        '${GenerateConstants.blueColorCode} $keyStr ${GenerateConstants.redColorCode}$errorMessage${GenerateConstants.resetColorCode}',
      );
    }
    counter++;
  });

  // Remove trailing comma from last line
  final List<String> linesAfterWrite = buffer.toString().trim().split('\n');
  String lastLineOfLinesAfterWrite = linesAfterWrite.last.trimRight();

  if (lastLineOfLinesAfterWrite.isNotEmpty &&
      lastLineOfLinesAfterWrite[lastLineOfLinesAfterWrite.length - 1] == ',') {
    lastLineOfLinesAfterWrite = lastLineOfLinesAfterWrite.substring(
      0,
      lastLineOfLinesAfterWrite.length - 1,
    );
    linesAfterWrite[linesAfterWrite.length - 1] = lastLineOfLinesAfterWrite;
    buffer.clear();
    buffer.writeAll(linesAfterWrite, '\n');
  }

  buffer.writeln();
  buffer.writeln('}');

  await file.writeAsString(buffer.toString());
  print(
    '${GenerateConstants.greenColorCode} Lang Json File ($lang) Updated successfully at $filePath ${GenerateConstants.resetColorCode}',
  );

  return json.decode(buffer.toString());
}

Future<void> generateAppStrings(Map<String, dynamic> jsonMap) async {
  final StringBuffer buffer = StringBuffer();

  buffer.writeln(
    'import \'package:easy_localization/easy_localization.dart\';',
  );
  buffer.writeln();
  buffer.writeln('abstract class LocaleKeys {');

  jsonMap.forEach((String key, _) {
    try {
      final Names keyNames = Names.fromString(key);
      buffer.writeln(
        "  static const String _${keyNames.camelCase} = '${keyNames.original}';",
      );
      buffer.writeln(
        '  static String get ${keyNames.camelCase} => _${keyNames.camelCase}.tr();',
      );
      buffer.writeln();
    } on NamesException {
      final String keyStr = '[$key]';
      const String errorMessage = 'is not valid!';
      print(
        '${GenerateConstants.blueColorCode} $keyStr ${GenerateConstants.redColorCode}$errorMessage${GenerateConstants.resetColorCode}',
      );
    }
  });

  buffer.writeln('}');

  final File file = File(GenerateConstants.outputStringsFilePath);
  await file.writeAsString(buffer.toString());
  print(
    '${GenerateConstants.greenColorCode} class AppStrings Generated successfully at ${GenerateConstants.outputStringsFilePath} ${GenerateConstants.resetColorCode}',
  );
}
