import 'package:emun/features/listings/domain/repositories/favorites_repository.dart';
import 'package:emun/features/listings/infrastructure/datasources/favorites_remote_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this._remoteDataSource);

  final FavoritesRemoteDataSource _remoteDataSource;
  Set<String> _favoriteIds = <String>{};

  @override
  Future<Set<String>> fetchFavorites() async {
    _favoriteIds = await _remoteDataSource.fetchFavorites();
    return Set<String>.from(_favoriteIds);
  }

  @override
  Future<void> toggleFavorite(String listingId) async {
    await _remoteDataSource.toggleFavorite(listingId);
    await fetchFavorites();
  }

  @override
  bool isFavorite(String listingId) => _favoriteIds.contains(listingId);
}
