// ignore_for_file: invalid_use_of_visible_for_testing_member

export 'admin_event.dart';
export 'admin_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/features/admin/application/bloc/admin_event.dart';
import 'package:emun/features/admin/application/bloc/admin_state.dart';
import 'package:emun/features/admin/domain/repositories/admin_repository.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc(this._repository) : super(const AdminState()) {
    on<AdminLoadRequested>((event, emit) async {
      await load();
    });
  }

  final AdminRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    try {
      final reports = await _repository.fetchReports();
      final categories = await _repository.fetchCategories();
      emit(
        state.copyWith(
          isLoading: false,
          reports: reports,
          categories: categories,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }
}
