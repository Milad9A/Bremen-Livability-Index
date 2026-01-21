import 'dart:async';

import 'package:bli/features/auth/models/favorite_address.dart';
import 'package:bli/features/favorites/bloc/favorites_event.dart';
import 'package:bli/features/favorites/bloc/favorites_state.dart';
import 'package:bli/features/favorites/services/favorites_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesService _favoritesService;
  StreamSubscription<List<FavoriteAddress>>? _favoritesSubscription;

  FavoritesBloc({required FavoritesService favoritesService})
    : _favoritesService = favoritesService,
      super(const FavoritesState()) {
    on<LoadFavoritesRequested>(_onLoadFavoritesRequested);
    on<AddFavoriteRequested>(_onAddFavoriteRequested);
    on<RemoveFavoriteRequested>(_onRemoveFavoriteRequested);
    on<FavoritesUpdated>(_onFavoritesUpdated);
    on<ClearFavorites>(_onClearFavorites);
  }

  Future<void> _onLoadFavoritesRequested(
    LoadFavoritesRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    await _favoritesSubscription?.cancel();
    _favoritesSubscription = _favoritesService
        .getFavorites(event.userId)
        .listen(
          (favorites) => add(FavoritesUpdated(favorites)),
          onError: (error) {
            add(FavoritesUpdated([]));
          },
        );
  }

  Future<void> _onFavoritesUpdated(
    FavoritesUpdated event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(state.copyWith(favorites: event.favorites, isLoading: false));
  }

  Future<void> _onAddFavoriteRequested(
    AddFavoriteRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await _favoritesService.addFavorite(event.userId, event.address);
    } catch (e) {
      emit(state.copyWith(error: 'Failed to add favorite: $e'));
    }
  }

  Future<void> _onRemoveFavoriteRequested(
    RemoveFavoriteRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await _favoritesService.removeFavorite(event.userId, event.addressId);
    } catch (e) {
      emit(state.copyWith(error: 'Failed to remove favorite: $e'));
    }
  }

  Future<void> _onClearFavorites(
    ClearFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    await _favoritesSubscription?.cancel();
    _favoritesSubscription = null;
    emit(const FavoritesState());
  }

  @override
  Future<void> close() {
    _favoritesSubscription?.cancel();
    return super.close();
  }
}
