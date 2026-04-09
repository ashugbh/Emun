import 'package:equatable/equatable.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, failure }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.isAuthenticated = false,
    this.currentUserId,
    this.error,
  });

  final AuthStatus status;
  final bool isAuthenticated;
  final String? currentUserId;
  final String? error;

  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthStatus? status,
    bool? isAuthenticated,
    String? currentUserId,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      currentUserId: currentUserId ?? this.currentUserId,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isAuthenticated,
        currentUserId,
        error,
      ];
}
