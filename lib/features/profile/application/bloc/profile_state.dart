import 'package:equatable/equatable.dart';
import 'package:emun/features/listings/domain/entities/listing.dart';
import 'package:emun/features/profile/domain/entities/user_profile.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.isLoading = false,
    this.profile,
    this.listings = const [],
    this.error,
  });

  final bool isLoading;
  final UserProfile? profile;
  final List<Listing> listings;
  final String? error;

  ProfileState copyWith({
    bool? isLoading,
    UserProfile? profile,
    List<Listing>? listings,
    String? error,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      listings: listings ?? this.listings,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, profile, listings, error];
}
