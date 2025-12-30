import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import '../viewmodels/map_viewmodel.dart';
import '../widgets/score_card.dart';
import '../widgets/address_search.dart';
import '../widgets/nearby_feature_layers.dart';
import '../widgets/glass_container.dart';
import '../widgets/floating_search_bar.dart';
import '../widgets/loading_overlay.dart';
import '../theme/app_theme.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapViewModel(),
      child: const _MapScreenContent(),
    );
  }
}

class _MapScreenContent extends StatelessWidget {
  const _MapScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MapViewModel>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
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
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                            : Colors.teal,
                        size: 50,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
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
                color: Colors.red[50],
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
