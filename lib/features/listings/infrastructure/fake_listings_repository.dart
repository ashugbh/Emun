import 'package:emun/core/services/fake_emun_api.dart';
import 'package:emun/features/listings/domain/entities/category.dart';
import 'package:emun/features/listings/domain/entities/listing.dart';
import 'package:emun/features/listings/domain/entities/listing_draft.dart';
import 'package:emun/features/listings/domain/entities/search_query.dart';
import 'package:emun/features/listings/domain/repositories/listings_repository.dart';

class FakeListingsRepository implements ListingsRepository {
  FakeListingsRepository(this._api);

  final FakeEmunApi _api;

  @override
  Future<List<Category>> fetchCategories() => _api.fetchCategories();

  @override
  Future<List<Listing>> fetchFeaturedListings() => _api.fetchFeaturedListings();

  @override
  Future<List<Listing>> fetchLatestListings() => _api.fetchLatestListings();

  @override
  Future<List<Listing>> searchListings(ListingsSearchQuery query) => _api.searchListings(query);

  @override
  Future<Listing?> fetchListing(String id) => _api.fetchListing(id);

  @override
  Future<List<Listing>> fetchListingsBySeller(String sellerId) => _api.fetchListingsBySeller(sellerId);

  @override
  Future<List<Listing>> fetchRelatedListings({
    required String categoryId,
    required String excludeListingId,
  }) => _api.fetchRelatedListings(categoryId: categoryId, excludeListingId: excludeListingId);

  @override
  Future<Listing> createListing(ListingDraft draft) => _api.createListing(draft);
}
