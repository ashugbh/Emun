import 'package:emun/core/services/fake_emun_api.dart';
import 'package:emun/features/admin/domain/entities/moderation_report.dart';
import 'package:emun/features/admin/domain/repositories/admin_repository.dart';
import 'package:emun/features/listings/domain/entities/category.dart';

class FakeAdminRepository implements AdminRepository {
  FakeAdminRepository(this._api);

  final FakeEmunApi _api;

  @override
  Future<List<ModerationReport>> fetchReports() => _api.fetchReports();

  @override
  Future<List<Category>> fetchCategories() => _api.fetchCategories();
}
