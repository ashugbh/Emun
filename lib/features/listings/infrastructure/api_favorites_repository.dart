import 'package:emun/core/services/backend_emun_api.dart';
import 'package:emun/features/listings/domain/repositories/favorites_repository.dart';

class ApiFavoritesRepository implements FavoritesRepository {
  ApiFavoritesRepository(this._api);

  final BackendEmunApi _api;
  Set<String> _favoriteIds = <String>{};

  @override
  Future<Set<String>> fetchFavorites() async {
    _favoriteIds = await _api.fetchFavoriteIds();
    return Set<String>.from(_favoriteIds);
  }

  @override
  Future<void> toggleFavorite(String listingId) async {
    await _api.toggleFavorite(listingId);
    await fetchFavorites();
  }

  @override
  bool isFavorite(String listingId) => _favoriteIds.contains(listingId);
}
