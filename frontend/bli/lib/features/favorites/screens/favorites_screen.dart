import 'package:bli/core/widgets/liquid_back_button.dart';
import 'package:bli/features/auth/bloc/auth_bloc.dart';

import 'package:bli/features/favorites/bloc/favorites_bloc.dart';
import 'package:bli/features/favorites/bloc/favorites_event.dart';
import 'package:bli/features/favorites/bloc/favorites_state.dart';
import 'package:bli/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bli/core/widgets/safe_liquid_glass_view.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late final LiquidButtonManager _backButtonManager;

  @override
  void initState() {
    super.initState();
    _backButtonManager = LiquidButtonManager(this, vsync: this);
  }

  @override
  void dispose() {
    _backButtonManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _backButtonManager.animation,
      builder: (context, child) {
        return SafeLiquidGlassView(
          backgroundWidget: Scaffold(
            appBar: AppBar(
              title: const Text('Saved Places'),
              automaticallyImplyLeading: false,
              toolbarHeight: 64,
              leadingWidth: 68,
              centerTitle: true,
              backgroundColor: AppColors.white,
              leading: const SizedBox(),
            ),
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
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.favorite_border_rounded,
                            size: 48,
                            color: AppColors.primaryLight,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'No saved places yet',
                          style: AppTextStyles.subheading.copyWith(
                            color: AppColors.greyMedium,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your favorite locations will appear here',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 14,
                            color: AppColors.greyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                  itemCount: state.favorites.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final favorite = state.favorites[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.greyLight.withValues(alpha: 0.5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            Navigator.pop(context, favorite);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    Icons.location_on_rounded,
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        favorite.label,
                                        style: AppTextStyles.subheading
                                            .copyWith(fontSize: 16),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${favorite.latitude.toStringAsFixed(4)}, ${favorite.longitude.toStringAsFixed(4)}',
                                        style: AppTextStyles.caption.copyWith(
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete_outline_rounded,
                                    color: AppColors.error.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                                  onPressed: () {
                                    final userId = context
                                        .read<AuthBloc>()
                                        .state
                                        .user
                                        ?.id;
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          children: [_backButtonManager.buildLens(context)],
        );
      },
    );
  }
}
