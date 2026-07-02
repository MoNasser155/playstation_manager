import 'dart:io';

class MachineIdService {
  Future<String> getId() async {
    if (!Platform.isWindows) return 'non-windows';
    try {
      final result = await Process.run('powershell', [
        '-NoProfile',
        '-NonInteractive',
        '-Command',
        r'(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Cryptography").MachineGuid',
      ]);
      final guid = (result.stdout as String).trim();
      if (guid.isNotEmpty) return guid;
    } catch (_) {}
    return '${Platform.localHostname}_${Platform.environment['USERNAME'] ?? 'unknown'}';
  }
}
