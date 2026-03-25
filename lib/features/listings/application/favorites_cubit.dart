import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/features/listings/domain/repositories/favorites_repository.dart';

class FavoritesState extends Equatable {
  final Set<String> ids;

  const FavoritesState({this.ids = const {}});

  FavoritesState copyWith({Set<String>? ids}) {
    return FavoritesState(ids: ids ?? this.ids);
  }

  @override
  List<Object?> get props => [ids];
}

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this._repository) : super(const FavoritesState());

  final FavoritesRepository _repository;

  Future<void> load() async {
    final ids = await _repository.fetchFavorites();
    emit(state.copyWith(ids: ids));
  }

  Future<void> toggle(String listingId) async {
    await _repository.toggleFavorite(listingId);
    await load();
  }

  bool isFavorite(String listingId) => state.ids.contains(listingId);
}
