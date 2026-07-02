import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

import '../errors/exceptions.dart';
import '../objectbox/objectbox_store.dart';
import '../shared/di.dart';
import 'restart_app.dart';

enum BackupStatus {
  idle,
  success,
  failure;

  bool get isSuccess => this == BackupStatus.success;
  bool get isFailure => this == BackupStatus.failure;
  bool get isIdle => this == BackupStatus.idle;
}

enum RestoreStatus {
  idle,
  success,
  failure;

  bool get isSuccess => this == RestoreStatus.success;
  bool get isFailure => this == RestoreStatus.failure;
  bool get isIdle => this == RestoreStatus.idle;
}

class BackupService {
  static Future<BackupStatus> createBackup() async {
    final store = sl<ObjectBoxStore>();
    final dbPath = store.store.directoryPath;

    store.store.close();
    await sl.unregister<ObjectBoxStore>();
    ObjectBoxStore.reset();

    try {
      final sourceDir = Directory(dbPath);
      if (!await sourceDir.exists()) throw BackupSourceNotFoundException();
      await _copyDirectory(sourceDir, Directory(_buildBackupPath()));
      return BackupStatus.success;
    } on AppException {
      rethrow;
    } catch (_) {
      throw BackupCreationFailedException();
    } finally {
      Future.delayed(const Duration(milliseconds: 1000), () {
        RestartService.restartApp();
      });
    }
  }

  Future<String?> pickBackupFolder() async {
    final initialDir = p.join(_exeDir, 'backups');
    await Directory(initialDir).create(recursive: true);
    final result = await FilePicker.getDirectoryPath(
      dialogTitle: 'Select Backup Folder',
      initialDirectory: initialDir,
    );
    return result;
  }

  Future<RestoreStatus> restoreBackup(String backupPath) async {
    final store = sl<ObjectBoxStore>();
    final dbPath = store.store.directoryPath;

    store.store.close();
    await sl.unregister<ObjectBoxStore>();
    ObjectBoxStore.reset();

    try {
      final currentDb = Directory(dbPath);
      if (await currentDb.exists()) await currentDb.delete(recursive: true);
      await _copyDirectory(Directory(backupPath), currentDb);
      return RestoreStatus.success;
    } on AppException {
      rethrow;
    } catch (_) {
      throw RestoreFailedException();
    } finally {
      Future.delayed(const Duration(milliseconds: 1000), () {
        RestartService.restartApp();
      });
    }
  }

  static String get _exeDir => p.dirname(Platform.resolvedExecutable);

  static String _buildBackupPath() {
    final timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
    return p.join(_exeDir, 'backups', timestamp);
  }

  static Future<void> _copyDirectory(Directory source, Directory dest) async {
    await dest.create(recursive: true);
    await for (final entity in source.list(recursive: false)) {
      final destPath = p.join(dest.path, p.basename(entity.path));
      if (entity is File) {
        await entity.copy(destPath);
      } else if (entity is Directory) {
        await _copyDirectory(entity, Directory(destPath));
      }
    }
  }

  static Future<List<FileSystemEntity>> listBackups() async {
    final backupsDir = Directory(p.join(_exeDir, 'backups'));
    if (!await backupsDir.exists()) return [];

    final entries = await backupsDir.list().toList();
    entries.sort((a, b) => b.path.compareTo(a.path));
    return entries;
  }

  static Future<void> pruneBackups({int keepLatest = 10}) async {
    final backups = await listBackups();
    if (backups.length <= keepLatest) return;
    for (final old in backups.sublist(keepLatest)) {
      await old.delete(recursive: true);
    }
  }
}
