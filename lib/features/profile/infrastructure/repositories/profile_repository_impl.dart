import 'package:emun/features/listings/domain/entities/listing.dart';
import 'package:emun/features/profile/domain/entities/user_profile.dart';
import 'package:emun/features/profile/domain/repositories/profile_repository.dart';
import 'package:emun/features/profile/infrastructure/datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<UserProfile> fetchProfile() => _remoteDataSource.fetchProfile();

  @override
  Future<List<Listing>> fetchMyListings() => _remoteDataSource.fetchMyListings();
}
