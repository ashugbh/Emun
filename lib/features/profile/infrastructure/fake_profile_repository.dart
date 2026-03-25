import 'package:emun/core/services/fake_emun_api.dart';
import 'package:emun/features/listings/domain/entities/listing.dart';
import 'package:emun/features/profile/domain/entities/user_profile.dart';
import 'package:emun/features/profile/domain/repositories/profile_repository.dart';

class FakeProfileRepository implements ProfileRepository {
  FakeProfileRepository(this._api);

  final FakeEmunApi _api;

  @override
  Future<UserProfile> fetchProfile() => _api.fetchProfile();

  @override
  Future<List<Listing>> fetchMyListings() async {
    final profile = await _api.fetchProfile();
    return _api.fetchListingsBySeller(profile.id);
  }
}
