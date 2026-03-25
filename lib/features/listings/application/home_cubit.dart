import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/features/listings/domain/entities/category.dart';
import 'package:emun/features/listings/domain/entities/listing.dart';
import 'package:emun/features/listings/domain/repositories/listings_repository.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final List<Category> categories;
  final List<Listing> featured;
  final List<Listing> latest;
  final String? error;

  const HomeState({
    this.isLoading = false,
    this.categories = const [],
    this.featured = const [],
    this.latest = const [],
    this.error,
  });

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

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repository) : super(const HomeState());

  final ListingsRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    try {
      final categories = await _repository.fetchCategories();
      final featured = await _repository.fetchFeaturedListings();
      final latest = await _repository.fetchLatestListings();
      emit(state.copyWith(
        isLoading: false,
        categories: categories,
        featured: featured,
        latest: latest,
      ));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }
}
