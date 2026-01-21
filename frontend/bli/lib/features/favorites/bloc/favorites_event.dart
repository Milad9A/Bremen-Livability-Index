import 'package:bli/features/auth/models/favorite_address.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorites_event.freezed.dart';

@freezed
class FavoritesEvent with _$FavoritesEvent {
  const factory FavoritesEvent.loadFavoritesRequested(String userId) =
      LoadFavoritesRequested;
  const factory FavoritesEvent.addFavoriteRequested(
    String userId,
    FavoriteAddress address,
  ) = AddFavoriteRequested;
  const factory FavoritesEvent.removeFavoriteRequested(
    String userId,
    String addressId,
  ) = RemoveFavoriteRequested;
  const factory FavoritesEvent.favoritesUpdated(
    List<FavoriteAddress> favorites,
  ) = FavoritesUpdated;
  const factory FavoritesEvent.clearFavorites() = ClearFavorites;
}
