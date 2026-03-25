import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/features/listings/domain/entities/listing.dart';
import 'package:emun/features/listings/domain/entities/listing_draft.dart';
import 'package:emun/features/listings/domain/repositories/listings_repository.dart';

enum CreateListingStatus { idle, saving, success, failure }

class CreateListingState extends Equatable {
  final CreateListingStatus status;
  final Listing? listing;
  final String? error;

  const CreateListingState({
    this.status = CreateListingStatus.idle,
    this.listing,
    this.error,
  });

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

class CreateListingCubit extends Cubit<CreateListingState> {
  CreateListingCubit(this._repository) : super(const CreateListingState());

  final ListingsRepository _repository;

  Future<void> submit(ListingDraft draft) async {
    emit(state.copyWith(status: CreateListingStatus.saving));
    try {
      final listing = await _repository.createListing(draft);
      emit(state.copyWith(status: CreateListingStatus.success, listing: listing));
      emit(state.copyWith(status: CreateListingStatus.idle));
    } catch (error) {
      emit(state.copyWith(status: CreateListingStatus.failure, error: error.toString()));
    }
  }
}
