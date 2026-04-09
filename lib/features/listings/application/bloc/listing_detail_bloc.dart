// ignore_for_file: invalid_use_of_visible_for_testing_member

export 'listing_detail_event.dart';
export 'listing_detail_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/features/listings/application/bloc/listing_detail_event.dart';
import 'package:emun/features/listings/application/bloc/listing_detail_state.dart';
import 'package:emun/features/listings/domain/repositories/listings_repository.dart';

class ListingDetailBloc extends Bloc<ListingDetailEvent, ListingDetailState> {
  ListingDetailBloc(this._repository, this.listingId)
      : super(const ListingDetailState()) {
    on<ListingDetailLoadRequested>((event, emit) async {
      await load();
    });
  }

  final ListingsRepository _repository;
  final String listingId;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    try {
      final listing = await _repository.fetchListing(listingId);
      if (listing == null) {
        emit(
          state.copyWith(
            isLoading: false,
            listing: null,
            relatedListings: const [],
          ),
        );
        return;
      }
      final relatedListings = await _repository.fetchRelatedListings(
        categoryId: listing.categoryId,
        excludeListingId: listing.id,
      );
      emit(
        state.copyWith(
          isLoading: false,
          listing: listing,
          relatedListings: relatedListings,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }
}
