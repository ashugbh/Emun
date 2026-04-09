sealed class FavoritesEvent {
  const FavoritesEvent();
}

final class FavoritesLoadRequested extends FavoritesEvent {
  const FavoritesLoadRequested();
}

final class FavoriteToggled extends FavoritesEvent {
  const FavoriteToggled(this.listingId);

  final String listingId;
}
