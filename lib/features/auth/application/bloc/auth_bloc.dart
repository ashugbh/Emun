// ignore_for_file: invalid_use_of_visible_for_testing_member

export 'auth_event.dart';
export 'auth_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/features/auth/application/bloc/auth_event.dart';
import 'package:emun/features/auth/application/bloc/auth_state.dart';
import 'package:emun/features/auth/domain/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repository)
      : super(
          AuthState(
            status: _repository.isAuthenticated
                ? AuthStatus.authenticated
                : AuthStatus.initial,
            isAuthenticated: _repository.isAuthenticated,
            currentUserId: _repository.currentUserId,
          ),
        ) {
    on<AuthLoginRequested>((event, emit) async {
      await login(
        identifier: event.identifier,
        password: event.password,
      );
    });
    on<AuthRegisterRequested>((event, emit) async {
      await register(
        name: event.name,
        identifier: event.identifier,
        password: event.password,
      );
    });
    on<AuthLogoutRequested>((event, emit) async {
      await logout();
    });
  }

  final AuthRepository _repository;

  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));
    try {
      await _repository.login(identifier: identifier, password: password);
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          isAuthenticated: true,
          currentUserId: _repository.currentUserId,
          error: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          isAuthenticated: false,
          currentUserId: null,
          error: error.toString(),
        ),
      );
    }
  }

  Future<void> register({
    required String name,
    required String identifier,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));
    try {
      await _repository.register(
        name: name,
        identifier: identifier,
        password: password,
      );
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          isAuthenticated: true,
          currentUserId: _repository.currentUserId,
          error: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          isAuthenticated: false,
          currentUserId: null,
          error: error.toString(),
        ),
      );
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));
    try {
      await _repository.logout();
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          isAuthenticated: false,
          currentUserId: null,
          error: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          error: error.toString(),
        ),
      );
    }
  }
}
