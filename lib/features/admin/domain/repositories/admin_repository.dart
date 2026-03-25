import 'package:emun/features/admin/domain/entities/moderation_report.dart';
import 'package:emun/features/listings/domain/entities/category.dart';

abstract class AdminRepository {
  Future<List<ModerationReport>> fetchReports();
  Future<List<Category>> fetchCategories();
}
