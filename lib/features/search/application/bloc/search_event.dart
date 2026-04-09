import 'package:emun/features/listings/domain/entities/search_query.dart';
import 'package:emun/features/search/application/bloc/search_state.dart';

sealed class SearchEvent {
  const SearchEvent();
}

final class SearchLoadRequested extends SearchEvent {
  const SearchLoadRequested();
}

final class SearchQueryChanged extends SearchEvent {
  const SearchQueryChanged(this.value);

  final String value;
}

final class SearchCategoryChanged extends SearchEvent {
  const SearchCategoryChanged(this.value);

  final String? value;
}

final class SearchConditionChanged extends SearchEvent {
  const SearchConditionChanged(this.value);

  final String? value;
}

final class SearchSortChanged extends SearchEvent {
  const SearchSortChanged(this.value);

  final ListingSort value;
}

final class SearchPriceRangeChanged extends SearchEvent {
  const SearchPriceRangeChanged(this.minPrice, this.maxPrice);

  final double? minPrice;
  final double? maxPrice;
}

final class SearchPresetApplied extends SearchEvent {
  const SearchPresetApplied(this.preset);

  final SearchPreset preset;
}

final class SearchPresetSaved extends SearchEvent {
  const SearchPresetSaved();
}

final class SearchRequested extends SearchEvent {
  const SearchRequested();
}
