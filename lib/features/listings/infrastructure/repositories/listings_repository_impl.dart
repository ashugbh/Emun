import 'package:emun/features/listings/domain/entities/category.dart';
import 'package:emun/features/listings/domain/entities/listing.dart';
import 'package:emun/features/listings/domain/entities/listing_draft.dart';
import 'package:emun/features/listings/domain/entities/search_query.dart';
import 'package:emun/features/listings/domain/repositories/listings_repository.dart';
import 'package:emun/features/listings/infrastructure/datasources/listings_remote_data_source.dart';

class ListingsRepositoryImpl implements ListingsRepository {
  ListingsRepositoryImpl(this._remoteDataSource);

  final ListingsRemoteDataSource _remoteDataSource;

  @override
  Future<List<Category>> fetchCategories() => _remoteDataSource.fetchCategories();

  @override
  Future<List<Listing>> fetchFeaturedListings() =>
      _remoteDataSource.fetchFeaturedListings();

  @override
  Future<List<Listing>> fetchLatestListings() =>
      _remoteDataSource.fetchLatestListings();

  @override
  Future<List<Listing>> searchListings(ListingsSearchQuery query) =>
      _remoteDataSource.searchListings(query);

  @override
  Future<Listing?> fetchListing(String id) => _remoteDataSource.fetchListing(id);

  @override
  Future<List<Listing>> fetchListingsBySeller(String sellerId) =>
      _remoteDataSource.fetchListingsBySeller(sellerId);

  @override
  Future<List<Listing>> fetchRelatedListings({
    required String categoryId,
    required String excludeListingId,
  }) {
    return _remoteDataSource.fetchRelatedListings(
      categoryId: categoryId,
      excludeListingId: excludeListingId,
    );
  }

  @override
  Future<Listing> createListing(ListingDraft draft) =>
      _remoteDataSource.createListing(draft);
}
