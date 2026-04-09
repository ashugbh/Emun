import 'package:equatable/equatable.dart';
import 'package:emun/features/listings/domain/entities/listing.dart';

class ListingDetailState extends Equatable {
  const ListingDetailState({
    this.isLoading = false,
    this.listing,
    this.relatedListings = const [],
    this.error,
  });

  final bool isLoading;
  final Listing? listing;
  final List<Listing> relatedListings;
  final String? error;

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
