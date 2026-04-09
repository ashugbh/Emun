import 'package:emun/core/services/backend_emun_api.dart';
import 'package:emun/core/services/fake_emun_api.dart';
import 'package:emun/features/listings/domain/entities/listing.dart';
import 'package:emun/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfile> fetchProfile();
  Future<List<Listing>> fetchMyListings();
}

class ApiProfileRemoteDataSource implements ProfileRemoteDataSource {
  ApiProfileRemoteDataSource(this._api);

  final BackendEmunApi _api;

  @override
  Future<UserProfile> fetchProfile() => _api.fetchProfile();

  @override
  Future<List<Listing>> fetchMyListings() async {
    final profile = await _api.fetchProfile();
    return _api.fetchListingsBySeller(profile.id);
  }
}

class FakeProfileRemoteDataSource implements ProfileRemoteDataSource {
  FakeProfileRemoteDataSource(this._api);

  final FakeEmunApi _api;

  @override
  Future<UserProfile> fetchProfile() => _api.fetchProfile();

  @override
  Future<List<Listing>> fetchMyListings() async {
    final profile = await _api.fetchProfile();
    return _api.fetchListingsBySeller(profile.id);
  }
}
