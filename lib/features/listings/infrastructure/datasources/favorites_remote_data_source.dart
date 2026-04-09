import 'package:emun/core/services/backend_emun_api.dart';
abstract class FavoritesRemoteDataSource {
  Future<Set<String>> fetchFavorites();
  Future<void> toggleFavorite(String listingId);
}

class ApiFavoritesRemoteDataSource implements FavoritesRemoteDataSource {
  ApiFavoritesRemoteDataSource(this._api);

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
}

class FakeFavoritesRemoteDataSource implements FavoritesRemoteDataSource {
  final Set<String> _favoriteIds = <String>{};

  @override
  Future<Set<String>> fetchFavorites() async {
    return Set<String>.from(_favoriteIds);
  }

  @override
  Future<void> toggleFavorite(String listingId) async {
    if (_favoriteIds.contains(listingId)) {
      _favoriteIds.remove(listingId);
    } else {
      _favoriteIds.add(listingId);
    }
  }
}
