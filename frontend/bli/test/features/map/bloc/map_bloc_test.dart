import 'package:bli/features/map/bloc/map_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('MapBloc', () {
    late MapBloc bloc;

    setUp(() {
      bloc = MapBloc();
    });

    tearDown(() {
      bloc.close();
    });

    group('Bremen bounds checking', () {
      test('bremenCenter is within Bremen bounds', () {
        expect(bloc.isWithinBremen(MapBloc.bremenCenter), true);
      });

      test('point inside Bremen returns true', () {
        // City center
        expect(bloc.isWithinBremen(const LatLng(53.0793, 8.8017)), true);
        // Near Hauptbahnhof
        expect(bloc.isWithinBremen(const LatLng(53.0833, 8.8142)), true);
        // Vegesack
        expect(bloc.isWithinBremen(const LatLng(53.1667, 8.6167)), true);
      });

      test('point outside Bremen returns false', () {
        // Hamburg
        expect(bloc.isWithinBremen(const LatLng(53.5511, 9.9937)), false);
        // Berlin
        expect(bloc.isWithinBremen(const LatLng(52.5200, 13.4050)), false);
        // Too far south
        expect(bloc.isWithinBremen(const LatLng(52.90, 8.8017)), false);
        // Too far north
        expect(bloc.isWithinBremen(const LatLng(53.30, 8.8017)), false);
        // Too far west
        expect(bloc.isWithinBremen(const LatLng(53.0793, 8.40)), false);
        // Too far east
        expect(bloc.isWithinBremen(const LatLng(53.0793, 9.10)), false);
      });

      test('points on Bremen boundary are included', () {
        // Min latitude boundary
        expect(bloc.isWithinBremen(const LatLng(52.96, 8.8017)), true);
        // Max latitude boundary
        expect(bloc.isWithinBremen(const LatLng(53.22, 8.8017)), true);
        // Min longitude boundary
        expect(bloc.isWithinBremen(const LatLng(53.0793, 8.48)), true);
        // Max longitude boundary
        expect(bloc.isWithinBremen(const LatLng(53.0793, 9.01)), true);
      });
    });

    group('Initial state', () {
      test('selectedMarker is null initially', () {
        expect(bloc.state.selectedMarker, isNull);
      });

      test('currentScore is null initially', () {
        expect(bloc.state.currentScore, isNull);
      });

      test('isLoading is false initially', () {
        expect(bloc.state.isLoading, false);
      });

      test('showSearch is false initially', () {
        expect(bloc.state.showSearch, false);
      });

      test('showSlowLoadingMessage is false initially', () {
        expect(bloc.state.showSlowLoadingMessage, false);
      });
    });

    group('SearchToggled event', () {
      blocTest<MapBloc, MapState>(
        'emits state with showSearch true when searchToggled(true)',
        build: () => MapBloc(),
        act: (bloc) => bloc.add(const MapEvent.searchToggled(true)),
        expect: () => [
          predicate<MapState>((state) => state.showSearch == true),
        ],
      );

      blocTest<MapBloc, MapState>(
        'emits state with showSearch false when searchToggled(false)',
        build: () => MapBloc(),
        seed: () => const MapState(showSearch: true),
        act: (bloc) => bloc.add(const MapEvent.searchToggled(false)),
        expect: () => [
          predicate<MapState>((state) => state.showSearch == false),
        ],
      );
    });

    group('ErrorCleared event', () {
      blocTest<MapBloc, MapState>(
        'clears error message',
        build: () => MapBloc(),
        seed: () => const MapState(errorMessage: 'Some error'),
        act: (bloc) => bloc.add(const MapEvent.errorCleared()),
        expect: () => [
          predicate<MapState>((state) => state.errorMessage == null),
        ],
      );
    });

    group('MapReset event', () {
      blocTest<MapBloc, MapState>(
        'clears selectedMarker, currentScore, and errorMessage',
        build: () => MapBloc(),
        seed: () => const MapState(errorMessage: 'Error'),
        act: (bloc) => bloc.add(const MapEvent.mapReset()),
        expect: () => [
          predicate<MapState>(
            (state) =>
                state.selectedMarker == null &&
                state.currentScore == null &&
                state.errorMessage == null,
          ),
        ],
      );
    });

    group('Constants', () {
      test('bremenCenter has correct coordinates', () {
        expect(MapBloc.bremenCenter.latitude, 53.0793);
        expect(MapBloc.bremenCenter.longitude, 8.8017);
      });

      test('Bremen bounding box is valid', () {
        expect(MapBloc.bremenMinLat, lessThan(MapBloc.bremenMaxLat));
        expect(MapBloc.bremenMinLon, lessThan(MapBloc.bremenMaxLon));
      });

      test('bremenCenter is within bounding box', () {
        expect(
          MapBloc.bremenCenter.latitude,
          greaterThanOrEqualTo(MapBloc.bremenMinLat),
        );
        expect(
          MapBloc.bremenCenter.latitude,
          lessThanOrEqualTo(MapBloc.bremenMaxLat),
        );
        expect(
          MapBloc.bremenCenter.longitude,
          greaterThanOrEqualTo(MapBloc.bremenMinLon),
        );
        expect(
          MapBloc.bremenCenter.longitude,
          lessThanOrEqualTo(MapBloc.bremenMaxLon),
        );
      });
    });

    group('onShowMessage callback', () {
      test('onShowMessage is null initially', () {
        expect(bloc.onShowMessage, isNull);
      });

      test('onShowMessage can be set', () {
        String? receivedMessage;
        bloc.onShowMessage = (message) => receivedMessage = message;
        bloc.onShowMessage?.call('Test message');
        expect(receivedMessage, 'Test message');
      });
    });

    group('mapController', () {
      test('mapController is not null', () {
        expect(bloc.mapController, isNotNull);
      });
    });

    group('MapTapped event', () {
      blocTest<MapBloc, MapState>(
        'closes search when search is active and map is tapped',
        build: () => MapBloc(),
        seed: () => const MapState(showSearch: true),
        act: (bloc) => bloc.add(MapEvent.mapTapped(MapBloc.bremenCenter)),
        expect: () => [
          predicate<MapState>((state) => state.showSearch == false),
        ],
      );

      test('shows message when tapping outside Bremen', () {
        String? capturedMessage;
        bloc.onShowMessage = (message) => capturedMessage = message;

        // Tap outside Bremen (Hamburg)
        bloc.add(const MapEvent.mapTapped(LatLng(53.5511, 9.9937)));

        // Give the bloc time to process
        Future.delayed(const Duration(milliseconds: 100), () {
          expect(capturedMessage, contains('Bremen'));
        });
      });

      test('does not emit state when tapping outside Bremen', () async {
        final initialState = bloc.state;

        // Tap outside Bremen
        bloc.add(const MapEvent.mapTapped(LatLng(53.5511, 9.9937)));
        await Future.delayed(const Duration(milliseconds: 50));

        // State should remain unchanged (no loading, no marker)
        expect(bloc.state.isLoading, initialState.isLoading);
        expect(bloc.state.selectedMarker, initialState.selectedMarker);
      });
    });

    group('MapState', () {
      test('initial state has correct default values', () {
        final state = MapState.initial();
        expect(state.selectedMarker, isNull);
        expect(state.currentScore, isNull);
        expect(state.isLoading, false);
        expect(state.errorMessage, isNull);
        expect(state.showSearch, false);
        expect(state.showSlowLoadingMessage, false);
      });

      test('copyWith preserves values when not specified', () {
        const state = MapState(
          isLoading: true,
          showSearch: true,
          errorMessage: 'Test error',
        );

        final newState = state.copyWith(isLoading: false);

        expect(newState.isLoading, false);
        expect(newState.showSearch, true); // preserved
        expect(newState.errorMessage, 'Test error'); // preserved
      });

      test('copyWith can set nullable fields to null', () {
        const state = MapState(errorMessage: 'Test error');

        final newState = state.copyWith(errorMessage: null);

        expect(newState.errorMessage, isNull);
      });

      test('states with same values are equal', () {
        const state1 = MapState(isLoading: true, showSearch: false);
        const state2 = MapState(isLoading: true, showSearch: false);

        expect(state1, equals(state2));
      });

      test('states with different values are not equal', () {
        const state1 = MapState(isLoading: true);
        const state2 = MapState(isLoading: false);

        expect(state1, isNot(equals(state2)));
      });
    });

    group('MapEvent equality', () {
      test('searchToggled events with same value are equal', () {
        const event1 = MapEvent.searchToggled(true);
        const event2 = MapEvent.searchToggled(true);
        expect(event1, equals(event2));
      });

      test('searchToggled events with different values are not equal', () {
        const event1 = MapEvent.searchToggled(true);
        const event2 = MapEvent.searchToggled(false);
        expect(event1, isNot(equals(event2)));
      });

      test('mapTapped events with same position are equal', () {
        const event1 = MapEvent.mapTapped(LatLng(53.0, 8.8));
        const event2 = MapEvent.mapTapped(LatLng(53.0, 8.8));
        expect(event1, equals(event2));
      });

      test('mapReset events are equal', () {
        const event1 = MapEvent.mapReset();
        const event2 = MapEvent.mapReset();
        expect(event1, equals(event2));
      });

      test('errorCleared events are equal', () {
        const event1 = MapEvent.errorCleared();
        const event2 = MapEvent.errorCleared();
        expect(event1, equals(event2));
      });
    });
  });
}
