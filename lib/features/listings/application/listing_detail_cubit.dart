import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/features/listings/domain/entities/listing.dart';
import 'package:emun/features/listings/domain/repositories/listings_repository.dart';

class ListingDetailState extends Equatable {
  final bool isLoading;
  final Listing? listing;
  final List<Listing> relatedListings;
  final String? error;

  const ListingDetailState({
    this.isLoading = false,
    this.listing,
    this.relatedListings = const [],
    this.error,
  });

  ListingDetailState copyWith({
    bool? isLoading,
    Listing? listing,
    List<Listing>? relatedListings,
    String? error,
  }) {
    return ListingDetailState(
      isLoading: isLoading ?? this.isLoading,
      listing: listing ?? this.listing,
      relatedListings: relatedListings ?? this.relatedListings,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, listing, relatedListings, error];
}

class ListingDetailCubit extends Cubit<ListingDetailState> {
  ListingDetailCubit(this._repository, this.listingId)
      : super(const ListingDetailState());

  final ListingsRepository _repository;
  final String listingId;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    try {
      final listing = await _repository.fetchListing(listingId);
      if (listing == null) {
        emit(state.copyWith(isLoading: false, listing: null, relatedListings: const []));
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
