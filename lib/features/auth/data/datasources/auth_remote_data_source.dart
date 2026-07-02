import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/local_auth_server.dart';
import '../../../../core/services/machine_id_service.dart';
import '../../../../core/shared/di.dart';
import '../models/app_user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<AppUserModel> signInWithGoogle();
  Future<AppUserModel?> getCurrentUser();
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl();
  final _supabase = sl<SupabaseClient>();
  final _machineId = sl<MachineIdService>();
  final _localServer = sl<LocalAuthServer>();

  @override
  Future<AppUserModel> signInWithGoogle() async {
    try {
      final callbackFuture = _localServer.waitForCallback().timeout(
        const Duration(minutes: 5),
        onTimeout: () => throw TimeoutException('OAuth timed out'),
      );

      final launched = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: _localServer.callbackUrl,
        authScreenLaunchMode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw GoogleSignInCancelledException();
      }

      final callbackUri = await callbackFuture;
      final code = callbackUri.queryParameters['code'];
      if (code == null) {
        throw GoogleSignInFailedException();
      }
      await _supabase.auth.exchangeCodeForSession(code);

      final supaUser = _supabase.auth.currentUser;
      if (supaUser == null) {
        throw ServerErrorException();
      }

      return await _registerAndVerify(supaUser);
    } on TimeoutException {
      await _localServer.dispose();
      throw GoogleSignInTimedOutException();
    } on AuthException catch (_) {
      throw ServerErrorException();
    }
  }

  @override
  Future<AppUserModel?> getCurrentUser() async {
    try {
      final supaUser = _supabase.auth.currentUser;
      if (supaUser == null) return null;

      final record =
          await _supabase
              .from('app_users')
              .select()
              .eq('user_id', supaUser.id)
              .maybeSingle();

      if (record == null) return null;

      final currentMachineId = await _machineId.getId();
      final storedMachineId = record['machine_id'] as String;

      if (storedMachineId != currentMachineId) {
        await _supabase.auth.signOut();
        throw MachineMismatchException();
      }

      return AppUserModel.fromJson(record);
    } on AuthException catch (_) {
      throw ServerErrorException();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } on AuthException catch (_) {
      throw ServerErrorException();
    }
  }

  Future<AppUserModel> _registerAndVerify(User supaUser) async {
    final currentMachineId = await _machineId.getId();

    await _supabase
        .from('app_users')
        .upsert(
          {
            'user_id': supaUser.id,
            'email': supaUser.email ?? '',
            'machine_id': currentMachineId,
            'is_active': false,
          },
          onConflict: 'user_id',
          ignoreDuplicates: true,
        );

    final record =
        await _supabase
            .from('app_users')
            .select()
            .eq('user_id', supaUser.id)
            .single();

    final storedMachineId = record['machine_id'] as String;

    if (storedMachineId != currentMachineId) {
      await _supabase.auth.signOut();
      throw MachineMismatchException();
    }

    return AppUserModel.fromJson(record);
  }
}
