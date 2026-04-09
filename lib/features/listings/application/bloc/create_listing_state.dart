import 'package:equatable/equatable.dart';
import 'package:emun/features/listings/domain/entities/listing.dart';

enum CreateListingStatus { idle, saving, success, failure }

class CreateListingState extends Equatable {
  const CreateListingState({
    this.status = CreateListingStatus.idle,
    this.listing,
    this.error,
  });

  final CreateListingStatus status;
  final Listing? listing;
  final String? error;

  CreateListingState copyWith({
    CreateListingStatus? status,
    Listing? listing,
    String? error,
  }) {
    return CreateListingState(
      status: status ?? this.status,
      listing: listing ?? this.listing,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, listing, error];
}
