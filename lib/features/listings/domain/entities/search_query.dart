import 'package:equatable/equatable.dart';

enum ListingSort { newest, priceLowToHigh, priceHighToLow, relevance }

class ListingsSearchQuery extends Equatable {
  final String query;
  final String? categoryId;
  final String? condition;
  final double? minPrice;
  final double? maxPrice;
  final ListingSort sort;

  const ListingsSearchQuery({
    this.query = '',
    this.categoryId,
    this.condition,
    this.minPrice,
    this.maxPrice,
    this.sort = ListingSort.newest,
  });

  ListingsSearchQuery copyWith({
    String? query,
    String? categoryId,
    String? condition,
    double? minPrice,
    double? maxPrice,
    ListingSort? sort,
  }) {
    return ListingsSearchQuery(
      query: query ?? this.query,
      categoryId: categoryId ?? this.categoryId,
      condition: condition ?? this.condition,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sort: sort ?? this.sort,
    );
  }

  @override
  List<Object?> get props => [query, categoryId, condition, minPrice, maxPrice, sort];
}
