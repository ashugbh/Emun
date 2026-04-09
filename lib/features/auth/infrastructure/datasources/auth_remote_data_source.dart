import 'package:emun/core/constants/app_constants.dart';
import 'package:emun/core/services/backend_emun_api.dart';

abstract class AuthRemoteDataSource {
  bool get isAuthenticated;
  String? get currentUserId;

  Future<void> login({
    required String identifier,
    required String password,
  });

  Future<void> register({
    required String name,
    required String identifier,
    required String password,
  });

  Future<void> logout();
}

class ApiAuthRemoteDataSource implements AuthRemoteDataSource {
  ApiAuthRemoteDataSource(this._api);

  final BackendEmunApi _api;

  @override
  bool get isAuthenticated => _api.isAuthenticated;

  @override
  String? get currentUserId => _api.currentUserId;

  @override
  Future<void> login({
    required String identifier,
    required String password,
  }) {
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

class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  bool _isAuthenticated = false;
  String? _currentUserId;

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  String? get currentUserId => _currentUserId;

  @override
  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    await Future.delayed(AppConstants.fakeApiDelay);
    _isAuthenticated = true;
    _currentUserId = 'u1';
  }

  @override
  Future<void> register({
    required String name,
    required String identifier,
    required String password,
  }) async {
    await Future.delayed(AppConstants.fakeApiDelay);
    _isAuthenticated = true;
    _currentUserId = 'u1';
  }

  @override
  Future<void> logout() async {
    _isAuthenticated = false;
    _currentUserId = null;
  }
}
