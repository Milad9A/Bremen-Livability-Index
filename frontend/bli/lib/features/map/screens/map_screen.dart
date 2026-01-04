import 'package:bli/features/map/bloc/map_bloc.dart';
import 'package:bli/core/theme/app_theme.dart';
import 'package:bli/features/map/widgets/address_search.dart';
import 'package:bli/features/map/widgets/floating_search_bar.dart';
import 'package:bli/core/widgets/glass_container.dart';
import 'package:bli/core/widgets/loading_overlay.dart';
import 'package:bli/features/map/widgets/nearby_feature_layers.dart';
import 'package:bli/features/map/widgets/score_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart' hide MapEvent;

class MapScreen extends StatelessWidget {
  final MapBloc? bloc;

  const MapScreen({super.key, this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc ?? MapBloc(),
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
      final bloc = context.read<MapBloc>();
      bloc.onShowMessage = (message) {
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
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        final bloc = context.read<MapBloc>();

        return Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          extendBody: true,
          body: Stack(
            children: [
              FlutterMap(
                mapController: bloc.mapController,
                options: MapOptions(
                  initialCenter: MapBloc.bremenCenter,
                  initialZoom: 13.0,
                  minZoom: 10.0,
                  maxZoom: 18.0,
                  onTap: (tapPosition, point) =>
                      bloc.add(MapEvent.mapTapped(point)),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                    subdomains: const ['a', 'b', 'c', 'd'],
                    userAgentPackageName: 'com.example.bli',
                    maxZoom: 19,
                  ),
                  if (state.currentScore != null)
                    NearbyFeatureLayers(
                      nearbyFeatures: state.currentScore!.nearbyFeatures,
                    ),
                  if (state.selectedMarker != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: state.selectedMarker!.position,
                          width: 50,
                          height: 50,
                          child: Icon(
                            Icons.location_on,
                            color: state.selectedMarker!.score != null
                                ? getScoreColor(state.selectedMarker!.score!)
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

              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 16,
                right: 80,
                child: state.showSearch
                    ? AddressSearchWidget(
                        onLocationSelected: (location, addressName) => bloc.add(
                          MapEvent.locationSelected(location, addressName),
                        ),
                        onClose: () =>
                            bloc.add(const MapEvent.searchToggled(false)),
                      )
                    : FloatingSearchBar(
                        onTap: () =>
                            bloc.add(const MapEvent.searchToggled(true)),
                      ),
              ),

              if (state.errorMessage != null)
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
                              state.errorMessage!,
                              style: TextStyle(
                                color: AppColors.error,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () =>
                                bloc.add(const MapEvent.errorCleared()),
                            color: AppColors.error,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              if (state.isLoading)
                LoadingOverlay(
                  showSlowLoadingMessage: state.showSlowLoadingMessage,
                ),

              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                right: 16,
                child: GestureDetector(
                  onTap: () => bloc.add(const MapEvent.mapReset()),
                  child: GlassContainer(
                    borderRadius: 30,
                    padding: const EdgeInsets.all(14),
                    child: Icon(
                      Icons.my_location,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ),

              if (state.currentScore != null)
                Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: ScoreCard(score: state.currentScore!),
                ),
            ],
          ),
        );
      },
    );
  }
}
