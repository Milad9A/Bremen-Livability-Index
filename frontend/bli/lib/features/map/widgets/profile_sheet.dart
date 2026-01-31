import 'package:bli/core/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:bli/features/auth/bloc/auth_bloc.dart';
import 'package:bli/features/auth/bloc/auth_event.dart';
import 'package:bli/features/auth/models/favorite_address.dart';
import 'package:bli/features/favorites/screens/favorites_screen.dart';
import 'package:bli/features/map/bloc/map_bloc.dart';
import 'package:bli/features/preferences/bloc/preferences_bloc.dart';
import 'package:bli/features/preferences/screens/preferences_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

class ProfileSheet extends StatelessWidget {
  const ProfileSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState.user;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            behavior: HitTestBehavior.translucent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.greyLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Icon(
                      user?.isAnonymous == true
                          ? Icons.person_outline
                          : Icons.person,
                      size: 40,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.displayName ??
                        (user?.isAnonymous == true ? 'Guest User' : 'User'),
                    style: AppTextStyles.subheading,
                  ),
                  if (user?.email != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      user!.email!,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.greyMedium,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  if (user?.isAnonymous == true)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Sign in with an account to save your favorites',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.greyMedium,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (user?.isAnonymous == false) ...[
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final navigator = Navigator.of(context);
                          final mapBloc = context.read<MapBloc>();
                          navigator.pop();
                          final result = await navigator.push(
                            MaterialPageRoute(
                              builder: (_) => const FavoritesScreen(),
                            ),
                          );

                          if (result != null && result is FavoriteAddress) {
                            mapBloc.add(
                              MapEvent.locationSelected(
                                LatLng(result.latitude, result.longitude),
                                result.label,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.favorite_border),
                        label: const Text('Saved Places'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: AppColors.primary),
                          foregroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<PreferencesBloc>(),
                              child: const PreferencesScreen(),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.tune),
                      label: const Text('Score Preferences'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: AppColors.primary),
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<AuthBloc>().add(const SignOutRequested());
                      },
                      icon: const Icon(Icons.logout),
                      label: Text(
                        user?.isAnonymous == true
                            ? 'Sign In with Account'
                            : 'Sign Out',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: user?.isAnonymous == true
                            ? AppColors.primary
                            : AppColors.error,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
