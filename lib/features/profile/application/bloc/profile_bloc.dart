// ignore_for_file: invalid_use_of_visible_for_testing_member

export 'profile_event.dart';
export 'profile_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/features/listings/domain/repositories/listings_repository.dart';
import 'package:emun/features/profile/application/bloc/profile_event.dart';
import 'package:emun/features/profile/application/bloc/profile_state.dart';
import 'package:emun/features/profile/domain/repositories/profile_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._repository, this._listingsRepository)
      : super(const ProfileState()) {
    on<ProfileLoadRequested>((event, emit) async {
      await load();
    });
  }

  final ProfileRepository _repository;
  final ListingsRepository _listingsRepository;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    try {
      final profile = await _repository.fetchProfile();
      final listings = await _listingsRepository.fetchListingsBySeller(profile.id);
      emit(
        state.copyWith(
          isLoading: false,
          profile: profile,
          listings: listings,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }
}
