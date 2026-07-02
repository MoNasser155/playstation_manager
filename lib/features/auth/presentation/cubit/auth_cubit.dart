import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/google_sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.initial());

  static AuthCubit get(context) => BlocProvider.of(context);

  final _googleSignInUsecase = sl<GoogleSignInUseCase>();
  final _getCurrentUserUseCase = sl<GetCurrentUserUseCase>();
  final _signOutUseCase = sl<SignOutUseCase>();

  Future<void> checkCurrentUser() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _getCurrentUserUseCase();
    result.fold(
      (failure) {
        if (failure is MachineMismatchFailure) {
          emit(state.copyWith(status: AuthStatus.machineMismatch));
        } else {
          emit(state.copyWith(status: AuthStatus.unAuthenticated));
        }
      },
      (user) {
        if (user == null) {
          emit(state.copyWith(status: AuthStatus.unAuthenticated));
        } else {
          if (user.isActive) {
            emit(state.copyWith(status: AuthStatus.authenticated, user: user));
          } else {
            emit(state.copyWith(status: AuthStatus.pending, user: user));
          }
        }
      },
    );
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _googleSignInUsecase();
    result.fold(
      (failure) {
        if (failure is MachineMismatchFailure) {
          emit(state.copyWith(status: AuthStatus.machineMismatch));
        } else {
          emit(
            state.copyWith(
              status: AuthStatus.error,
              errorMessage: failure.message,
            ),
          );
        }
      },
      (user) {
        if (user.isActive) {
          emit(state.copyWith(status: AuthStatus.authenticated, user: user));
        } else {
          emit(state.copyWith(status: AuthStatus.pending, user: user));
        }
      },
    );
  }

  Future<void> signOut() async {
    emit(state.copyWith(status: AuthStatus.loading));

    await _signOutUseCase.call();
    emit(state.copyWith(status: AuthStatus.unAuthenticated, user: null));
  }
}
