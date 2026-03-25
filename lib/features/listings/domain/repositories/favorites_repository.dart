abstract class FavoritesRepository {
  Future<Set<String>> fetchFavorites();
  Future<void> toggleFavorite(String listingId);
  bool isFavorite(String listingId);
}
