import 'package:emun/core/services/backend_emun_api.dart';
import 'package:emun/features/listings/domain/entities/listing.dart';
import 'package:emun/features/profile/domain/entities/user_profile.dart';
import 'package:emun/features/profile/domain/repositories/profile_repository.dart';

class ApiProfileRepository implements ProfileRepository {
  ApiProfileRepository(this._api);

  final BackendEmunApi _api;

  @override
  Future<UserProfile> fetchProfile() => _api.fetchProfile();

  @override
  Future<List<Listing>> fetchMyListings() async {
    final profile = await _api.fetchProfile();
    return _api.fetchListingsBySeller(profile.id);
  }
}
