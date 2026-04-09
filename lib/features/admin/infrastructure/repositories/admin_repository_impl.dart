import 'package:emun/features/admin/domain/entities/moderation_report.dart';
import 'package:emun/features/admin/domain/repositories/admin_repository.dart';
import 'package:emun/features/admin/infrastructure/datasources/admin_remote_data_source.dart';
import 'package:emun/features/listings/domain/entities/category.dart';

class AdminRepositoryImpl implements AdminRepository {
  AdminRepositoryImpl(this._remoteDataSource);

  final AdminRemoteDataSource _remoteDataSource;

  @override
  Future<List<ModerationReport>> fetchReports() =>
      _remoteDataSource.fetchReports();

  @override
  Future<List<Category>> fetchCategories() =>
      _remoteDataSource.fetchCategories();
}
