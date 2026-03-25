abstract class AuthRepository {
  bool get isAuthenticated;
  String? get currentUserId;
  Future<void> login({required String identifier, required String password});
  Future<void> register({required String name, required String identifier, required String password});
  Future<void> logout();
}
