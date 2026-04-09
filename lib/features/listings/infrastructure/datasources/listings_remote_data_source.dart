import 'package:emun/core/services/backend_emun_api.dart';
import 'package:emun/core/services/fake_emun_api.dart';
import 'package:emun/features/listings/domain/entities/category.dart';
import 'package:emun/features/listings/domain/entities/listing.dart';
import 'package:emun/features/listings/domain/entities/listing_draft.dart';
import 'package:emun/features/listings/domain/entities/search_query.dart';

abstract class ListingsRemoteDataSource {
  Future<List<Category>> fetchCategories();
  Future<List<Listing>> fetchFeaturedListings();
  Future<List<Listing>> fetchLatestListings();
  Future<List<Listing>> searchListings(ListingsSearchQuery query);
  Future<Listing?> fetchListing(String id);
  Future<List<Listing>> fetchListingsBySeller(String sellerId);
  Future<List<Listing>> fetchRelatedListings({
    required String categoryId,
    required String excludeListingId,
  });
  Future<Listing> createListing(ListingDraft draft);
}

class ApiListingsRemoteDataSource implements ListingsRemoteDataSource {
  ApiListingsRemoteDataSource(this._api);

  final BackendEmunApi _api;

  @override
  Future<List<Category>> fetchCategories() => _api.fetchCategories();

  @override
  Future<List<Listing>> fetchFeaturedListings() => _api.fetchFeaturedListings();

  @override
  Future<List<Listing>> fetchLatestListings() => _api.fetchLatestListings();

  @override
  Future<List<Listing>> searchListings(ListingsSearchQuery query) =>
      _api.searchListings(query);

  @override
  Future<Listing?> fetchListing(String id) => _api.fetchListing(id);

  @override
  Future<List<Listing>> fetchListingsBySeller(String sellerId) =>
      _api.fetchListingsBySeller(sellerId);

  @override
  Future<List<Listing>> fetchRelatedListings({
    required String categoryId,
    required String excludeListingId,
  }) {
    return _api.fetchRelatedListings(
      categoryId: categoryId,
      excludeListingId: excludeListingId,
    );
  }

  @override
  Future<Listing> createListing(ListingDraft draft) => _api.createListing(draft);
}

class FakeListingsRemoteDataSource implements ListingsRemoteDataSource {
  FakeListingsRemoteDataSource(this._api);

  final FakeEmunApi _api;

  @override
  Future<List<Category>> fetchCategories() => _api.fetchCategories();

  @override
  Future<List<Listing>> fetchFeaturedListings() => _api.fetchFeaturedListings();

  @override
  Future<List<Listing>> fetchLatestListings() => _api.fetchLatestListings();

  @override
  Future<List<Listing>> searchListings(ListingsSearchQuery query) =>
      _api.searchListings(query);

  @override
  Future<Listing?> fetchListing(String id) => _api.fetchListing(id);

  @override
  Future<List<Listing>> fetchListingsBySeller(String sellerId) =>
      _api.fetchListingsBySeller(sellerId);

  @override
  Future<List<Listing>> fetchRelatedListings({
    required String categoryId,
    required String excludeListingId,
  }) {
    return _api.fetchRelatedListings(
      categoryId: categoryId,
      excludeListingId: excludeListingId,
    );
  }

  @override
  Future<Listing> createListing(ListingDraft draft) => _api.createListing(draft);
}
