import 'package:emun/core/services/backend_emun_api.dart';
import 'package:emun/features/auth/domain/auth_repository.dart';

class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository(this._api);

  final BackendEmunApi _api;

  @override
  bool get isAuthenticated => _api.isAuthenticated;

  @override
  String? get currentUserId => _api.currentUserId;

  @override
  Future<void> login({required String identifier, required String password}) {
    return _api.login(identifier: identifier, password: password);
  }

  @override
  Future<void> register({
    required String name,
    required String identifier,
    required String password,
  }) {
    return _api.register(
      name: name,
      identifier: identifier,
      password: password,
    );
  }

  @override
  Future<void> logout() => _api.logout();
}
