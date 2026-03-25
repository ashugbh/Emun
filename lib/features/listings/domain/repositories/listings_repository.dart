import 'package:emun/features/listings/domain/entities/category.dart';
import 'package:emun/features/listings/domain/entities/listing.dart';
import 'package:emun/features/listings/domain/entities/listing_draft.dart';
import 'package:emun/features/listings/domain/entities/search_query.dart';

abstract class ListingsRepository {
  Future<List<Category>> fetchCategories();
  Future<List<Listing>> fetchFeaturedListings();
  Future<List<Listing>> fetchLatestListings();
  Future<List<Listing>> searchListings(ListingsSearchQuery query);
  Future<Listing?> fetchListing(String id);
  Future<List<Listing>> fetchListingsBySeller(String sellerId);
  Future<Listing> createListing(ListingDraft draft);
}
