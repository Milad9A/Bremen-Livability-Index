import 'package:bli/features/auth/bloc/auth_bloc.dart';

import 'package:bli/features/auth/bloc/auth_state.dart';
import 'package:bli/features/map/bloc/map_bloc.dart';
import 'package:bli/core/theme/app_theme.dart';
import 'package:bli/features/map/widgets/address_search.dart';
import 'package:bli/features/map/widgets/floating_search_bar.dart';
import 'package:bli/core/widgets/loading_overlay.dart';
import 'package:bli/core/widgets/error_message_card.dart';
import 'package:bli/core/widgets/message_snack_bar.dart';
import 'package:bli/features/map/widgets/nearby_feature_layers.dart';
import 'package:bli/features/map/widgets/score_card.dart';
import 'package:bli/features/map/widgets/map_control_buttons.dart';
import 'package:bli/features/preferences/bloc/preferences_bloc.dart';
import 'package:bli/features/preferences/bloc/preferences_state.dart';
import 'package:bli/features/preferences/screens/preferences_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_map/flutter_map.dart' hide MapEvent;

import 'package:bli/features/map/widgets/profile_sheet.dart';
import 'package:bli/features/map/widgets/smart_score_card.dart';

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
          ScaffoldMessenger.of(context).showMessageSnackBar(message);
        }
      };
      // Wire up preferences retrieval for API calls
      bloc.getPreferences = () {
        final prefsState = context.read<PreferencesBloc>().state;
        return prefsState.preferences.toJson();
      };
    });
  }

  void _showProfileSheet() {
    final mapBloc = context.read<MapBloc>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (modalContext) =>
          BlocProvider.value(value: mapBloc, child: const ProfileSheet()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (!state.isAuthenticated) {
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        }
      },
      child: BlocBuilder<MapBloc, MapState>(
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
                          onLocationSelected: (location, addressName) =>
                              bloc.add(
                                MapEvent.locationSelected(
                                  location,
                                  addressName,
                                ),
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
                    child: ErrorMessageCard(
                      message: state.errorMessage!,
                      onClose: () => bloc.add(const MapEvent.errorCleared()),
                    ),
                  ),

                if (state.isLoading)
                  LoadingOverlay(
                    showSlowLoadingMessage: state.showSlowLoadingMessage,
                  ),

                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  right: 16,
                  child: BlocBuilder<PreferencesBloc, PreferencesState>(
                    buildWhen: (prev, curr) =>
                        prev.isCustomized != curr.isCustomized,
                    builder: (context, prefsState) {
                      return MapControlButtons(
                        onProfileTap: () => _showProfileSheet(),
                        onResetTap: () => bloc.add(const MapEvent.mapReset()),
                        onSettingsTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<PreferencesBloc>(),
                                child: const PreferencesScreen(),
                              ),
                            ),
                          );
                        },
                        hasCustomPrefs: prefsState.isCustomized,
                      );
                    },
                  ),
                ),

                if (state.currentScore != null)
                  Positioned(
                    bottom: 20,
                    left: 16,
                    right: 16,
                    child: SmartScoreCard(
                      score: state.currentScore!,
                      selectedMarker: state.selectedMarker,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
