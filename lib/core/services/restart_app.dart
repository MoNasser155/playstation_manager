import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

class RestartService {
  static Future<void> restartApp() async {
  if (!kDebugMode) {
    final exe = Platform.resolvedExecutable;
    await Process.start(
      exe,
      ['--restarted'], // 👈 flag
      workingDirectory: p.dirname(exe),
      mode: ProcessStartMode.detached,
    );
    await Future.delayed(const Duration(milliseconds: 300));
    exit(0);
  }
}
}
