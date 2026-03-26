import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/features/listings/domain/entities/category.dart';
import 'package:emun/features/listings/domain/entities/listing.dart';
import 'package:emun/features/listings/domain/entities/search_query.dart';
import 'package:emun/features/listings/domain/repositories/listings_repository.dart';

const Object _unset = Object();

class SearchPreset extends Equatable {
  final String title;
  final String query;
  final String? categoryId;

  const SearchPreset({
    required this.title,
    required this.query,
    this.categoryId,
  });

  @override
  List<Object?> get props => [title, query, categoryId];
}

class SearchState extends Equatable {
  final bool isLoading;
  final String query;
  final String? categoryId;
  final String? condition;
  final double? minPrice;
  final double? maxPrice;
  final ListingSort sort;
  final List<Category> categories;
  final List<Listing> results;
  final List<SearchPreset> savedPresets;
  final String? error;

  const SearchState({
    this.isLoading = false,
    this.query = '',
    this.categoryId,
    this.condition,
    this.minPrice,
    this.maxPrice,
    this.sort = ListingSort.newest,
    this.categories = const [],
    this.results = const [],
    this.savedPresets = const [
      SearchPreset(title: 'Apartments', query: 'apartment', categoryId: 'homes'),
      SearchPreset(title: 'iPhones', query: 'iphone', categoryId: 'phones'),
      SearchPreset(title: 'SUV Deals', query: 'SUV', categoryId: 'vehicles'),
    ],
    this.error,
  });

  SearchState copyWith({
    bool? isLoading,
    String? query,
    Object? categoryId = _unset,
    Object? condition = _unset,
    Object? minPrice = _unset,
    Object? maxPrice = _unset,
    ListingSort? sort,
    List<Category>? categories,
    List<Listing>? results,
    List<SearchPreset>? savedPresets,
    String? error,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      query: query ?? this.query,
      categoryId: categoryId == _unset ? this.categoryId : categoryId as String?,
      condition: condition == _unset ? this.condition : condition as String?,
      minPrice: minPrice == _unset ? this.minPrice : minPrice as double?,
      maxPrice: maxPrice == _unset ? this.maxPrice : maxPrice as double?,
      sort: sort ?? this.sort,
      categories: categories ?? this.categories,
      results: results ?? this.results,
      savedPresets: savedPresets ?? this.savedPresets,
      error: error,
    );
  }

  ListingsSearchQuery toQuery() {
    return ListingsSearchQuery(
      query: query,
      categoryId: categoryId,
      condition: condition,
      minPrice: minPrice,
      maxPrice: maxPrice,
      sort: sort,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        query,
        categoryId,
        condition,
        minPrice,
        maxPrice,
        sort,
        categories,
        results,
        savedPresets,
        error,
      ];
}

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._repository) : super(const SearchState());

  final ListingsRepository _repository;

  Future<void> load() async {
    final categories = await _repository.fetchCategories();
    emit(state.copyWith(categories: categories));
  }

  void updateQuery(String value) => emit(state.copyWith(query: value));

  void updateCategory(String? value) => emit(state.copyWith(categoryId: value));

  void updateCondition(String? value) => emit(state.copyWith(condition: value));

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
    final next = [preset, ...state.savedPresets.where((item) => item.query != preset.query)];
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
