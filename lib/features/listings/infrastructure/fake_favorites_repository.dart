import 'package:emun/features/listings/domain/repositories/favorites_repository.dart';

class FakeFavoritesRepository implements FavoritesRepository {
  final Set<String> _favoriteIds = {};

  @override
  Future<Set<String>> fetchFavorites() async {
    return _favoriteIds;
  }

  @override
  Future<void> toggleFavorite(String listingId) async {
    if (_favoriteIds.contains(listingId)) {
      _favoriteIds.remove(listingId);
    } else {
      _favoriteIds.add(listingId);
    }
  }

  @override
  bool isFavorite(String listingId) => _favoriteIds.contains(listingId);
}
