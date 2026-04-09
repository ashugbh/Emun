import 'package:equatable/equatable.dart';
import 'package:emun/features/listings/domain/entities/category.dart';
import 'package:emun/features/listings/domain/entities/listing.dart';
import 'package:emun/features/listings/domain/entities/search_query.dart';

const Object _unset = Object();

class SearchPreset extends Equatable {
  const SearchPreset({
    required this.title,
    required this.query,
    this.categoryId,
  });

  final String title;
  final String query;
  final String? categoryId;

  @override
  List<Object?> get props => [title, query, categoryId];
}

class SearchState extends Equatable {
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
