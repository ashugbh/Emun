import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/features/listings/domain/entities/listing.dart';
import 'package:emun/features/listings/domain/repositories/listings_repository.dart';

class ListingDetailState extends Equatable {
  final bool isLoading;
  final Listing? listing;
  final String? error;

  const ListingDetailState({
    this.isLoading = false,
    this.listing,
    this.error,
  });

  ListingDetailState copyWith({
    bool? isLoading,
    Listing? listing,
    String? error,
  }) {
    return ListingDetailState(
      isLoading: isLoading ?? this.isLoading,
      listing: listing ?? this.listing,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, listing, error];
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
      emit(state.copyWith(isLoading: false, listing: listing));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }
}
