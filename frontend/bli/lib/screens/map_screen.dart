import 'package:bli/theme/app_theme.dart';
import 'package:bli/viewmodels/map_viewmodel.dart';
import 'package:bli/widgets/address_search.dart';
import 'package:bli/widgets/floating_search_bar.dart';
import 'package:bli/widgets/glass_container.dart';
import 'package:bli/widgets/loading_overlay.dart';
import 'package:bli/widgets/nearby_feature_layers.dart';
import 'package:bli/widgets/score_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatelessWidget {
  final MapViewModel? viewModel;

  const MapScreen({super.key, this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => viewModel ?? MapViewModel(),
      child: const _MapScreenContent(),
    );
  }
}

class _MapScreenContent extends StatefulWidget {
  const _MapScreenContent();

  @override
  State<_MapScreenContent> createState() => _MapScreenContentState();
}

class _MapScreenContentState extends State<_MapScreenContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<MapViewModel>();
      viewModel.onShowMessage = (message) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.white),
                  const SizedBox(width: 12),
                  Expanded(child: Text(message)),
                ],
              ),
              backgroundColor: AppColors.primaryDark,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MapViewModel>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          FlutterMap(
            mapController: viewModel.mapController,
            options: MapOptions(
              initialCenter: MapViewModel.bremenCenter,
              initialZoom: 13.0,
              minZoom: 10.0,
              maxZoom: 18.0,
              onTap: viewModel.onMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.example.bli',
                maxZoom: 19,
              ),
              if (viewModel.currentScore != null)
                NearbyFeatureLayers(
                  nearbyFeatures: viewModel.currentScore!.nearbyFeatures,
                ),
              if (viewModel.selectedMarker != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: viewModel.selectedMarker!.position,
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.location_on,
                        color: viewModel.selectedMarker!.score != null
                            ? getScoreColor(viewModel.selectedMarker!.score!)
                            : AppColors.primary,
                        size: 50,
                        shadows: [
                          Shadow(
                            color: AppColors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Search Bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 80, // Leave space for location button
            child: viewModel.showSearch
                ? AddressSearchWidget(
                    onLocationSelected: viewModel.onLocationSelected,
                    onClose: () => viewModel.toggleSearch(false),
                  )
                : FloatingSearchBar(onTap: () => viewModel.toggleSearch(true)),
          ),

          // Error Banner
          if (viewModel.errorMessage != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 80,
              left: 16,
              right: 16,
              child: Card(
                color: AppColors.errorBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: AppColors.error),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          viewModel.errorMessage!,
                          style: TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: viewModel.clearError,
                        color: AppColors.error,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Loading Overlay
          if (viewModel.isLoading)
            LoadingOverlay(
              showSlowLoadingMessage: viewModel.showSlowLoadingMessage,
            ),

          // Location Reset Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 16,
            child: GestureDetector(
              onTap: viewModel.resetMap,
              child: GlassContainer(
                borderRadius: 30,
                padding: const EdgeInsets.all(14),
                child: Icon(Icons.my_location, color: AppColors.primaryDark),
              ),
            ),
          ),

          // Score Card
          if (viewModel.currentScore != null)
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: ScoreCard(score: viewModel.currentScore!),
            ),
        ],
      ),
    );
  }
}
