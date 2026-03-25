import 'package:emun/core/constants/app_constants.dart';
import 'package:emun/features/auth/domain/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  bool _isAuthenticated = false;
  String? _currentUserId;

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  String? get currentUserId => _currentUserId;

  @override
  Future<void> login({required String identifier, required String password}) async {
    await Future.delayed(AppConstants.fakeApiDelay);
    _isAuthenticated = true;
    _currentUserId = 'u1';
  }

  @override
  Future<void> register({required String name, required String identifier, required String password}) async {
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
