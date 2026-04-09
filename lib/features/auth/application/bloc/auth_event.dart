sealed class AuthEvent {
  const AuthEvent();
}

final class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({
    required this.identifier,
    required this.password,
  });

  final String identifier;
  final String password;
}

final class AuthRegisterRequested extends AuthEvent {
  const AuthRegisterRequested({
    required this.name,
    required this.identifier,
    required this.password,
  });

  final String name;
  final String identifier;
  final String password;
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
