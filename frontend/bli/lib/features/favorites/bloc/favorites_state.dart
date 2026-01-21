import 'package:bli/features/auth/models/favorite_address.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorites_state.freezed.dart';

@freezed
class FavoritesState with _$FavoritesState {
  const factory FavoritesState({
    @Default([]) List<FavoriteAddress> favorites,
    @Default(false) bool isLoading,
    String? error,
  }) = _FavoritesState;
}
