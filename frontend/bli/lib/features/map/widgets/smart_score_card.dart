import 'package:bli/core/theme/app_theme.dart';
import 'package:bli/features/auth/bloc/auth_bloc.dart';
import 'package:bli/features/auth/models/favorite_address.dart';
import 'package:bli/features/favorites/bloc/favorites_bloc.dart';
import 'package:bli/features/favorites/bloc/favorites_event.dart';
import 'package:bli/features/favorites/bloc/favorites_state.dart';
import 'package:bli/features/map/models/location_marker.dart';
import 'package:bli/features/map/models/livability_score.dart';
import 'package:bli/features/map/widgets/score_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SmartScoreCard extends StatelessWidget {
  final LivabilityScore score;
  final LocationMarker? selectedMarker;

  const SmartScoreCard({super.key, required this.score, this.selectedMarker});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, favoritesState) {
        final markerAddress = selectedMarker?.address;
        final markerPos = selectedMarker?.position;

        final isFavorite = favoritesState.favorites.any((f) {
          if (markerAddress != null && f.label == markerAddress) {
            return true;
          }
          if (markerPos != null) {
            return (f.latitude - markerPos.latitude).abs() < 0.0001 &&
                (f.longitude - markerPos.longitude).abs() < 0.0001;
          }
          return false;
        });

        return ScoreCard(
          score: score,
          isFavorite: isFavorite,
          onFavoriteToggle: () {
            final authState = context.read<AuthBloc>().state;
            final userId = authState.user?.id;

            if (userId == null || authState.isGuest) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Please sign in to save favorites'),
                  backgroundColor: AppColors.error,
                ),
              );
              return;
            }

            if (isFavorite) {
              final favorite = favoritesState.favorites.firstWhere((f) {
                if (markerAddress != null && f.label == markerAddress) {
                  return true;
                }
                if (markerPos != null) {
                  return (f.latitude - markerPos.latitude).abs() < 0.0001 &&
                      (f.longitude - markerPos.longitude).abs() < 0.0001;
                }
                return false;
              });

              context.read<FavoritesBloc>().add(
                FavoritesEvent.removeFavoriteRequested(userId, favorite.id),
              );
            } else {
              final newFavorite = FavoriteAddress(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                label:
                    markerAddress ??
                    'Location ${markerPos?.latitude.toStringAsFixed(4)}, ${markerPos?.longitude.toStringAsFixed(4)}',
                latitude: markerPos!.latitude,
                longitude: markerPos.longitude,
                createdAt: DateTime.now(),
              );

              context.read<FavoritesBloc>().add(
                FavoritesEvent.addFavoriteRequested(userId, newFavorite),
              );
            }
          },
        );
      },
    );
  }
}
