// ignore_for_file: invalid_use_of_visible_for_testing_member

export 'home_event.dart';
export 'home_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/features/listings/application/bloc/home_event.dart';
import 'package:emun/features/listings/application/bloc/home_state.dart';
import 'package:emun/features/listings/domain/repositories/listings_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._repository) : super(const HomeState()) {
    on<HomeLoadRequested>((event, emit) async {
      await load();
    });
  }

  final ListingsRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    try {
      final categories = await _repository.fetchCategories();
      final featured = await _repository.fetchFeaturedListings();
      final latest = await _repository.fetchLatestListings();
      emit(
        state.copyWith(
          isLoading: false,
          categories: categories,
          featured: featured,
          latest: latest,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }
}
