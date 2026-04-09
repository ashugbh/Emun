import 'package:emun/core/services/backend_emun_api.dart';
import 'package:emun/core/services/fake_emun_api.dart';
import 'package:emun/features/admin/domain/entities/moderation_report.dart';
import 'package:emun/features/listings/domain/entities/category.dart';

abstract class AdminRemoteDataSource {
  Future<List<ModerationReport>> fetchReports();
  Future<List<Category>> fetchCategories();
}

class ApiAdminRemoteDataSource implements AdminRemoteDataSource {
  ApiAdminRemoteDataSource(this._api);

  final BackendEmunApi _api;

  @override
  Future<List<ModerationReport>> fetchReports() => _api.fetchReports();

  @override
  Future<List<Category>> fetchCategories() => _api.fetchCategories();
}

class FakeAdminRemoteDataSource implements AdminRemoteDataSource {
  FakeAdminRemoteDataSource(this._api);

  final FakeEmunApi _api;

  @override
  Future<List<ModerationReport>> fetchReports() => _api.fetchReports();

  @override
  Future<List<Category>> fetchCategories() => _api.fetchCategories();
}
