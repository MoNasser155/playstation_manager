abstract class GenerateConstants {
  // Print colors
  static const String blueColorCode = '\x1B[34m';
  static const String orangeColorCode = '\x1B[33m';
  static const String redColorCode = '\x1B[31m';
  static const String greenColorCode = '\x1B[32m';
  static const String resetColorCode = '\x1B[0m';
  
  // Generate strings
  static const String langJsonAssetFilePath = 'assets/translations/lang.json';
  static const String outputStringsFilePath = 'lib/core/languages/local_keys.g.dart';
  
  // Generate features
  static const String projectFeaturesPath = 'lib/src/features';
  static const String requestsAssetsPath = 'assets/requests';
  
  // Supported languages configuration
  // Add or remove languages here to support more languages
  static const List<String> supportedLanguages = [
    'en', // English
    'ar', // Arabic
    // Add more language codes as needed
  ];
  
  // Language file paths mapping
  static const Map<String, String> languageFilePaths = {
    'en': 'assets/translations/en.json',
    'ar': 'assets/translations/ar.json',
    // Add more mappings as needed
  };
  
  /// Get the file path for a specific language
  /// Returns empty string if language is not supported
  static String getLanguageFilePath(String languageCode) {
    return languageFilePaths[languageCode] ?? '';
  }
  
  /// Check if a language is supported
  static bool isLanguageSupported(String languageCode) {
    return supportedLanguages.contains(languageCode);
  }
  
  // Legacy constants for backward compatibility
  static const String langEnJsonAssetFilePath = 'assets/translations/en.json';
  static const String langArJsonAssetFilePath = 'assets/translations/ar.json';
}