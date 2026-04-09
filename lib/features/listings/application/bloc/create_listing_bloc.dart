// ignore_for_file: invalid_use_of_visible_for_testing_member

export 'create_listing_event.dart';
export 'create_listing_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/features/listings/application/bloc/create_listing_event.dart';
import 'package:emun/features/listings/application/bloc/create_listing_state.dart';
import 'package:emun/features/listings/domain/entities/listing_draft.dart';
import 'package:emun/features/listings/domain/repositories/listings_repository.dart';

class CreateListingBloc extends Bloc<CreateListingEvent, CreateListingState> {
  CreateListingBloc(this._repository) : super(const CreateListingState()) {
    on<CreateListingSubmitted>((event, emit) async {
      await submit(event.draft);
    });
  }

  final ListingsRepository _repository;

  Future<void> submit(ListingDraft draft) async {
    emit(state.copyWith(status: CreateListingStatus.saving, error: null));
    try {
      final listing = await _repository.createListing(draft);
      emit(
        state.copyWith(
          status: CreateListingStatus.success,
          listing: listing,
          error: null,
        ),
      );
      emit(state.copyWith(status: CreateListingStatus.idle));
    } catch (error) {
      emit(
        state.copyWith(
          status: CreateListingStatus.failure,
          error: error.toString(),
        ),
      );
    }
  }
}
