import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/features/listings/domain/entities/category.dart';
import 'package:emun/features/listings/domain/entities/listing.dart';
import 'package:emun/features/listings/domain/entities/search_query.dart';
import 'package:emun/features/listings/domain/repositories/listings_repository.dart';

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
    this.error,
  });

  SearchState copyWith({
    bool? isLoading,
    String? query,
    String? categoryId,
    String? condition,
    double? minPrice,
    double? maxPrice,
    ListingSort? sort,
    List<Category>? categories,
    List<Listing>? results,
    String? error,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      query: query ?? this.query,
      categoryId: categoryId ?? this.categoryId,
      condition: condition ?? this.condition,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sort: sort ?? this.sort,
      categories: categories ?? this.categories,
      results: results ?? this.results,
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
