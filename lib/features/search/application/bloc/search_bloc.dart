// ignore_for_file: invalid_use_of_visible_for_testing_member

export 'search_event.dart';
export 'search_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/features/listings/domain/entities/search_query.dart';
import 'package:emun/features/listings/domain/repositories/listings_repository.dart';
import 'package:emun/features/search/application/bloc/search_event.dart';
import 'package:emun/features/search/application/bloc/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._repository) : super(const SearchState()) {
    on<SearchLoadRequested>((event, emit) async {
      await load();
    });
    on<SearchQueryChanged>((event, emit) {
      updateQuery(event.value);
    });
    on<SearchCategoryChanged>((event, emit) {
      updateCategory(event.value);
    });
    on<SearchConditionChanged>((event, emit) {
      updateCondition(event.value);
    });
    on<SearchSortChanged>((event, emit) {
      updateSort(event.value);
    });
    on<SearchPriceRangeChanged>((event, emit) {
      updatePriceRange(event.minPrice, event.maxPrice);
    });
    on<SearchPresetApplied>((event, emit) {
      applyPreset(event.preset);
    });
    on<SearchPresetSaved>((event, emit) {
      saveCurrentSearch();
    });
    on<SearchRequested>((event, emit) async {
      await search();
    });
  }

  final ListingsRepository _repository;

  Future<void> load() async {
    final categories = await _repository.fetchCategories();
    emit(state.copyWith(categories: categories));
  }

  void updateQuery(String value) => emit(state.copyWith(query: value));

  void updateCategory(String? value) =>
      emit(state.copyWith(categoryId: value));

  void updateCondition(String? value) =>
      emit(state.copyWith(condition: value));

  void updateSort(ListingSort value) => emit(state.copyWith(sort: value));

  void updatePriceRange(double? minPrice, double? maxPrice) {
    emit(state.copyWith(minPrice: minPrice, maxPrice: maxPrice));
  }

  void applyPreset(SearchPreset preset) {
    emit(
      state.copyWith(
        query: preset.query,
        categoryId: preset.categoryId,
        condition: null,
        minPrice: null,
        maxPrice: null,
        sort: ListingSort.newest,
      ),
    );
    search();
  }

  void saveCurrentSearch() {
    if (state.query.trim().isEmpty) {
      return;
    }
    final preset = SearchPreset(
      title: state.query.trim(),
      query: state.query.trim(),
      categoryId: state.categoryId,
    );
    final next = [
      preset,
      ...state.savedPresets.where((item) => item.query != preset.query),
    ];
    emit(state.copyWith(savedPresets: next.take(6).toList()));
  }

  Future<void> search() async {
    emit(state.copyWith(isLoading: true));
    try {
      final results = await _repository.searchListings(state.toQuery());
      emit(state.copyWith(isLoading: false, results: results));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }
}
