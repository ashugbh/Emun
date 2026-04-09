import 'package:emun/features/listings/domain/entities/listing_draft.dart';

sealed class CreateListingEvent {
  const CreateListingEvent();
}

final class CreateListingSubmitted extends CreateListingEvent {
  const CreateListingSubmitted(this.draft);

  final ListingDraft draft;
}
