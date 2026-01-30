import 'package:bli/core/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:bli/core/widgets/error_message_card.dart';
import 'package:bli/core/widgets/message_snack_bar.dart';
import 'package:bli/features/auth/bloc/auth_bloc.dart';
import 'package:bli/features/auth/bloc/auth_state.dart';
import 'package:bli/features/map/bloc/map_bloc.dart';
import 'package:bli/features/map/models/models.dart';
import 'package:bli/features/map/widgets/address_search.dart';
import 'package:bli/features/map/widgets/nearby_feature_layers.dart';
import 'package:bli/features/map/widgets/profile_sheet.dart';
import 'package:bli/features/map/widgets/score_card.dart';
import 'package:bli/features/map/widgets/score_card_view.dart';
import 'package:bli/features/map/widgets/search_results_list.dart';
import 'package:bli/features/preferences/bloc/preferences_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart' hide MapEvent;
import 'package:latlong2/latlong.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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

class _MapScreenContentState extends State<_MapScreenContent>
    with TickerProviderStateMixin {
  List<GeocodeResult> _searchResults = [];
  bool _isSearching = false;
  String? _searchError;
  bool _hasSearchQuery = false;

  late final AnimationController _searchController;
  late final AnimationController _searchExpansionController;
  late final AnimationController _profileController;

  late final AnimationController _locationController;

  bool _isSearchPressed = false;
  bool _isProfilePressed = false;
  bool _isLocationPressed = false;

  @override
  void initState() {
    super.initState();

    _searchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      value: 1.0,
      upperBound: 2.0,
    )..addListener(() => setState(() {}));

    _searchExpansionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      value: 0.0,
    )..addListener(() => setState(() {}));

    _profileController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      value: 1.0,
      upperBound: 2.0,
    )..addListener(() => setState(() {}));

    _locationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      value: 1.0,
      upperBound: 2.0,
    )..addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<MapBloc>();
      bloc.onShowMessage = (message) {
        if (mounted) {
          ScaffoldMessenger.of(context).showMessageSnackBar(message);
        }
      };
      bloc.getPreferences = () {
        final prefsState = context.read<PreferencesBloc>().state;
        return prefsState.preferences.toJson();
      };
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchExpansionController.dispose();
    _profileController.dispose();

    _locationController.dispose();
    super.dispose();
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

  List<LiquidGlass> _buildLiquidGlassLenses(
    MapState state,
    MapBloc bloc,
    double screenWidth,
    double screenHeight,
    double topPadding,
  ) {
    final lenses = <LiquidGlass>[];

    double getCenteredOffset(double scale) => (56 * (scale - 1)) / 2;

    final expansionValue = _searchExpansionController.value;
    final buttonScale = _searchController.value;
    final collapsedSize = 56 * buttonScale;
    final expandedWidth = (screenWidth - 96).clamp(0.0, 500.0);

    final currentWidth =
        collapsedSize + (expandedWidth - collapsedSize) * expansionValue;

    final centeredOffset =
        getCenteredOffset(buttonScale) * (1 - expansionValue);

    final double effectMagnification = kIsWeb ? 1.0 : 1.05;
    final double effectDistortion = kIsWeb ? 0.0 : 0.10;

    lenses.add(
      LiquidGlass(
        width: currentWidth,
        height: 56,
        magnification: effectMagnification,
        distortion: effectDistortion,
        distortionWidth: 30,
        position: LiquidGlassOffsetPosition(
          left: 16 - centeredOffset,
          top: (topPadding + 10) - centeredOffset,
        ),
        shape: const RoundedRectangleShape(cornerRadius: 30),
        color: AppColors.white.withValues(alpha: 0.15),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: !state.showSearch
              ? GestureDetector(
                  key: const ValueKey('search_button'),
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (_) async {
                    _isSearchPressed = true;
                    await _searchController.animateTo(
                      0.92,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeOut,
                    );
                    if (_isSearchPressed) {
                      await _searchController.animateTo(
                        1.15,
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                  onTapUp: (_) async {
                    _isSearchPressed = false;
                    await _searchController.animateTo(
                      1.0,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeOut,
                    );
                    bloc.add(const MapEvent.searchToggled(true));
                  },
                  onTapCancel: () {
                    _isSearchPressed = false;
                    _searchController.animateTo(
                      1.0,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeOut,
                    );
                  },
                  child: Center(
                    child: Icon(
                      Icons.search,
                      color: AppColors.primaryDark,
                      size: 24,
                    ),
                  ),
                )
              : SizedBox(
                  key: const ValueKey('search_input'),
                  width: (screenWidth - 96).clamp(0.0, 500.0),
                  height: 56,
                  child: Center(
                    child: AddressSearchWidget(
                      onSearchStateChanged:
                          (results, isSearching, error, hasQuery) {
                            setState(() {
                              _searchResults = results;
                              _isSearching = isSearching;
                              _searchError = error;
                              _hasSearchQuery = hasQuery;
                            });
                          },
                      onLocationSelected: (location, addressName) => bloc.add(
                        MapEvent.locationSelected(location, addressName),
                      ),
                      onClose: () {
                        setState(() {
                          _searchResults = [];
                          _isSearching = false;
                          _searchError = null;
                          _hasSearchQuery = false;
                        });
                        bloc.add(const MapEvent.searchToggled(false));
                      },
                    ),
                  ),
                ),
        ),
      ),
    );

    if (_isSearching ||
        _searchError != null ||
        _searchResults.isNotEmpty ||
        (_hasSearchQuery && _searchResults.isEmpty)) {
      lenses.add(
        LiquidGlass(
          width: (screenWidth - 96).clamp(0.0, 500.0),
          height: 300,
          magnification: kIsWeb ? 1.0 : 1.03,
          distortion: kIsWeb ? 0.0 : 0.12,
          distortionWidth: 35,
          position: LiquidGlassOffsetPosition(
            left: 16,
            top: topPadding + 10 + 56 + 8,
          ),
          shape: const RoundedRectangleShape(cornerRadius: 20),
          color: AppColors.white.withValues(alpha: 0.15),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 300),
            child: SearchResultsList(
              isSearching: _isSearching,
              errorMessage: _searchError,
              searchResults: _searchResults,
              showNoResults: _searchResults.isEmpty && _hasSearchQuery,
              onResultSelected: (result) {
                final location = LatLng(result.latitude, result.longitude);
                bloc.add(
                  MapEvent.locationSelected(location, result.displayName),
                );
                setState(() {
                  _searchResults = [];
                  _isSearching = false;
                  _searchError = null;
                  _hasSearchQuery = false;
                });
              },
            ),
          ),
        ),
      );
    }

    final profileOffset = getCenteredOffset(_profileController.value);
    lenses.add(
      LiquidGlass(
        width: 56 * _profileController.value,
        height: 56 * _profileController.value,
        magnification: effectMagnification,
        distortion: effectDistortion,
        distortionWidth: 30,
        position: LiquidGlassOffsetPosition(
          right: 16 - profileOffset,
          top: (topPadding + 10) - profileOffset,
        ),
        shape: const RoundedRectangleShape(cornerRadius: 30),
        color: AppColors.white.withValues(alpha: 0.15),
        child: GestureDetector(
          onTapDown: (_) async {
            _isProfilePressed = true;
            await _profileController.animateTo(
              0.92,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
            );
            if (_isProfilePressed) {
              await _profileController.animateTo(
                1.15,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
              );
            }
          },
          onTapUp: (_) async {
            _isProfilePressed = false;
            await _profileController.animateTo(
              1.0,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
            );
            _showProfileSheet();
          },
          onTapCancel: () {
            _isProfilePressed = false;
            _profileController.animateTo(
              1.0,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
            );
          },
          child: ScaleTransition(
            scale: _profileController,
            child: Center(
              child: Icon(Icons.person, color: AppColors.primaryDark),
            ),
          ),
        ),
      ),
    );

    final locationOffset = getCenteredOffset(_locationController.value);
    lenses.add(
      LiquidGlass(
        width: 56 * _locationController.value,
        height: 56 * _locationController.value,
        magnification: effectMagnification,
        distortion: effectDistortion,
        distortionWidth: 30,
        position: LiquidGlassOffsetPosition(
          right: 16 - locationOffset,
          top: (topPadding + 78) - locationOffset,
        ),
        shape: const RoundedRectangleShape(cornerRadius: 30),
        color: AppColors.white.withValues(alpha: 0.15),
        child: GestureDetector(
          onTapDown: (_) async {
            HapticFeedback.lightImpact();
            _isLocationPressed = true;
            await _locationController.animateTo(
              0.92,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
            );
            if (_isLocationPressed) {
              await _locationController.animateTo(
                1.15,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
              );
            }
          },
          onTapUp: (_) async {
            _isLocationPressed = false;
            await _locationController.animateTo(
              1.0,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
            );
            bloc.add(const MapEvent.mapReset());
          },
          onTapCancel: () {
            _isLocationPressed = false;
            _locationController.animateTo(
              1.0,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
            );
          },
          child: ScaleTransition(
            scale: _locationController,
            child: Center(
              child: Icon(Icons.my_location, color: AppColors.primaryDark),
            ),
          ),
        ),
      ),
    );

    if (state.isLoading) {
      lenses.add(
        LiquidGlass(
          width: 80,
          height: 80,
          magnification: effectMagnification,
          distortion: effectDistortion,
          distortionWidth: 30,
          position: LiquidGlassOffsetPosition(
            left: (screenWidth - 80) / 2,
            top: (screenHeight - 80) / 2,
          ),
          shape: const RoundedRectangleShape(cornerRadius: 40),
          color: AppColors.white.withValues(alpha: 0.15),
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      );

      if (state.showSlowLoadingMessage) {
        lenses.add(
          LiquidGlass(
            width: screenWidth - 80,
            height: 200,
            magnification: effectMagnification,
            distortion: effectDistortion,
            distortionWidth: 30,
            position: LiquidGlassOffsetPosition(
              left: 40,
              top: (screenHeight / 2) + 60,
            ),
            shape: const RoundedRectangleShape(cornerRadius: 20),
            color: AppColors.white.withValues(alpha: 0.15),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 40,
                    color: AppColors.primaryDark,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Waking up server...',
                    style: AppTextStyles.subheading.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The backend is starting up. This may take up to 50 seconds.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(height: 1.4),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    return lenses;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (!state.isAuthenticated) {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/', (route) => false);
            }
          },
        ),
        BlocListener<MapBloc, MapState>(
          listener: (context, state) {
            if (state.showSearch) {
              _searchExpansionController.forward();
            } else {
              _searchExpansionController.reverse();
            }
          },
        ),
      ],
      child: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          final bloc = context.read<MapBloc>();
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;
          final topPadding = MediaQuery.of(context).padding.top;

          return Scaffold(
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: true,
            extendBody: true,
            body: Stack(
              children: [
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _searchExpansionController,
                    _searchController,
                    _profileController,
                    _locationController,
                  ]),
                  child: FlutterMap(
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
                                    ? getScoreColor(
                                        state.selectedMarker!.score!,
                                      )
                                    : AppColors.primary,
                                size: 50,
                                shadows: [
                                  Shadow(
                                    color: AppColors.black.withValues(
                                      alpha: 0.3,
                                    ),
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
                  builder: (context, child) {
                    return LiquidGlassView(
                      backgroundWidget: child!,
                      children: _buildLiquidGlassLenses(
                        state,
                        bloc,
                        screenWidth,
                        screenHeight,
                        topPadding,
                      ),
                    );
                  },
                ),

                if (state.errorMessage != null)
                  Positioned(
                    top: topPadding + 80,
                    left: 16,
                    right: 16,
                    child: ErrorMessageCard(
                      message: state.errorMessage!,
                      onClose: () => bloc.add(const MapEvent.errorCleared()),
                    ),
                  ),

                if (state.currentScore != null)
                  Positioned(
                    bottom: 20,
                    left: 16,
                    right: 16,
                    child: ScoreCard(
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
