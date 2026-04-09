import 'package:equatable/equatable.dart';
import 'package:emun/features/listings/domain/entities/category.dart';
import 'package:emun/features/listings/domain/entities/listing.dart';

class HomeState extends Equatable {
  const HomeState({
    this.isLoading = false,
    this.categories = const [],
    this.featured = const [],
    this.latest = const [],
    this.error,
  });

  final bool isLoading;
  final List<Category> categories;
  final List<Listing> featured;
  final List<Listing> latest;
  final String? error;

  HomeState copyWith({
    bool? isLoading,
    List<Category>? categories,
    List<Listing>? featured,
    List<Listing>? latest,
    String? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      featured: featured ?? this.featured,
      latest: latest ?? this.latest,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, categories, featured, latest, error];
}
