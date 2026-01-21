import 'package:bli/features/auth/bloc/auth_bloc.dart';
import 'package:bli/features/favorites/bloc/favorites_bloc.dart';
import 'package:bli/features/favorites/bloc/favorites_event.dart';
import 'package:bli/features/favorites/bloc/favorites_state.dart';
import 'package:bli/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Places'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: AppColors.greyLight,
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 56,
                    color: AppColors.greyMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No saved places yet',
                    style: TextStyle(color: AppColors.greyMedium, fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.favorites.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final favorite = state.favorites[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.location_on, color: AppColors.primary),
                  ),
                  title: Text(
                    favorite.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${favorite.latitude.toStringAsFixed(4)}, ${favorite.longitude.toStringAsFixed(4)}',
                    style: TextStyle(color: AppColors.greyMedium),
                  ),
                  onTap: () {
                    Navigator.pop(context, favorite);
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline, color: AppColors.error),
                    onPressed: () {
                      final userId = context.read<AuthBloc>().state.user?.id;
                      if (userId != null) {
                        context.read<FavoritesBloc>().add(
                          FavoritesEvent.removeFavoriteRequested(
                            userId,
                            favorite.id,
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
