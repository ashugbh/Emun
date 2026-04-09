import 'package:emun/features/auth/domain/auth_repository.dart';
import 'package:emun/features/auth/infrastructure/datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  bool get isAuthenticated => _remoteDataSource.isAuthenticated;

  @override
  String? get currentUserId => _remoteDataSource.currentUserId;

  @override
  Future<void> login({
    required String identifier,
    required String password,
  }) {
    return _remoteDataSource.login(identifier: identifier, password: password);
  }

  @override
  Future<void> register({
    required String name,
    required String identifier,
    required String password,
  }) {
    return _remoteDataSource.register(
      name: name,
      identifier: identifier,
      password: password,
    );
  }

  @override
  Future<void> logout() => _remoteDataSource.logout();
}
