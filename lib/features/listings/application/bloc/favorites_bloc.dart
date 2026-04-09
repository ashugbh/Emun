// ignore_for_file: invalid_use_of_visible_for_testing_member

export 'favorites_event.dart';
export 'favorites_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/features/listings/application/bloc/favorites_event.dart';
import 'package:emun/features/listings/application/bloc/favorites_state.dart';
import 'package:emun/features/listings/domain/repositories/favorites_repository.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc(this._repository) : super(const FavoritesState()) {
    on<FavoritesLoadRequested>((event, emit) async {
      await load();
    });
    on<FavoriteToggled>((event, emit) async {
      await toggle(event.listingId);
    });
  }

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
