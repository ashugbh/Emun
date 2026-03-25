import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/features/auth/domain/auth_repository.dart';

class AuthState extends Equatable {
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, isAuthenticated, error];
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState());

  final AuthRepository _repository;

  Future<void> login({required String identifier, required String password}) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _repository.login(identifier: identifier, password: password);
      emit(state.copyWith(isLoading: false, isAuthenticated: true));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }

  Future<void> register({required String name, required String identifier, required String password}) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _repository.register(name: name, identifier: identifier, password: password);
      emit(state.copyWith(isLoading: false, isAuthenticated: true));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }
}
