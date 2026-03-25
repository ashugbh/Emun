import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/features/admin/domain/entities/moderation_report.dart';
import 'package:emun/features/admin/domain/repositories/admin_repository.dart';
import 'package:emun/features/listings/domain/entities/category.dart';

class AdminState extends Equatable {
  final bool isLoading;
  final List<ModerationReport> reports;
  final List<Category> categories;
  final String? error;

  const AdminState({
    this.isLoading = false,
    this.reports = const [],
    this.categories = const [],
    this.error,
  });

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

class AdminCubit extends Cubit<AdminState> {
  AdminCubit(this._repository) : super(const AdminState());

  final AdminRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    try {
      final reports = await _repository.fetchReports();
      final categories = await _repository.fetchCategories();
      emit(state.copyWith(isLoading: false, reports: reports, categories: categories));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }
}
