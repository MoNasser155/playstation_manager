// import 'package:custom_phone_field/custom_phone_field.dart';

import '../languages/local_keys.g.dart';

class Validations {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.pleaseEnterEmail;
    }
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegex.hasMatch(value)) {
      return LocaleKeys.invalidEmail;
    }
    return null;
  }

  static String? validateEgyPhone(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.requiredField;
    }

    // Normalize: remove leading '0' if present
    String normalized = value.startsWith('0') ? value.substring(1) : value;

    // Must be exactly 10 digits after normalization
    if (normalized.length < 10) {
      return LocaleKeys.phoneMustBe10or11;
    }

    // Must contain digits only
    if (!RegExp(r'^\d+$').hasMatch(normalized)) {
      return LocaleKeys.phoneDigitsOnly;
    }

    // Must match Egyptian prefixes: 10, 11, 12, 15
    final validPrefixes = ['10', '11', '12', '15'];
    if (!validPrefixes.any((prefix) => normalized.startsWith(prefix))) {
      return LocaleKeys.phonePrefix;
    }

    return null;
  }

  static String? validateEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.requiredField;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.requiredField;
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    } else if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateWithLength(String? value, int length) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    } else if (value.length < length || value.length > length) {
      return 'This field must be $length characters';
    }
    return null;
  }
}
