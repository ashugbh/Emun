import 'package:emun/core/services/backend_emun_api.dart';
import 'package:emun/features/admin/domain/entities/moderation_report.dart';
import 'package:emun/features/admin/domain/repositories/admin_repository.dart';
import 'package:emun/features/listings/domain/entities/category.dart';

class ApiAdminRepository implements AdminRepository {
  ApiAdminRepository(this._api);

  final BackendEmunApi _api;

  @override
  Future<List<ModerationReport>> fetchReports() => _api.fetchReports();

  @override
  Future<List<Category>> fetchCategories() => _api.fetchCategories();
}
