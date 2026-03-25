import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/features/listings/domain/entities/listing.dart';
import 'package:emun/features/listings/domain/repositories/listings_repository.dart';
import 'package:emun/features/profile/domain/entities/user_profile.dart';
import 'package:emun/features/profile/domain/repositories/profile_repository.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final UserProfile? profile;
  final List<Listing> listings;
  final String? error;

  const ProfileState({
    this.isLoading = false,
    this.profile,
    this.listings = const [],
    this.error,
  });

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

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._repository, this._listingsRepository) : super(const ProfileState());

  final ProfileRepository _repository;
  final ListingsRepository _listingsRepository;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    try {
      final profile = await _repository.fetchProfile();
      final listings = await _listingsRepository.fetchListingsBySeller(profile.id);
      emit(state.copyWith(isLoading: false, profile: profile, listings: listings));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }
}
