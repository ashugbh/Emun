import 'package:equatable/equatable.dart';
import 'package:emun/features/admin/domain/entities/moderation_report.dart';
import 'package:emun/features/listings/domain/entities/category.dart';

class AdminState extends Equatable {
  const AdminState({
    this.isLoading = false,
    this.reports = const [],
    this.categories = const [],
    this.error,
  });

  final bool isLoading;
  final List<ModerationReport> reports;
  final List<Category> categories;
  final String? error;

  AdminState copyWith({
    bool? isLoading,
    List<ModerationReport>? reports,
    List<Category>? categories,
    String? error,
  }) {
    return AdminState(
      isLoading: isLoading ?? this.isLoading,
      reports: reports ?? this.reports,
      categories: categories ?? this.categories,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, reports, categories, error];
}
