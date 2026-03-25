import 'package:emun/features/listings/domain/entities/listing.dart';
import 'package:emun/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> fetchProfile();
  Future<List<Listing>> fetchMyListings();
}
