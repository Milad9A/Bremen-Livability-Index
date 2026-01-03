import 'package:flutter_test/flutter_test.dart';
import 'package:bli/viewmodels/map_viewmodel.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('MapViewModel', () {
    late MapViewModel viewModel;

    setUp(() {
      viewModel = MapViewModel();
    });

    tearDown(() {
      // Don't dispose in tearDown - some tests test dispose explicitly
    });

    group('Bremen bounds checking', () {
      test('bremenCenter is within Bremen bounds', () {
        expect(viewModel.isWithinBremen(MapViewModel.bremenCenter), true);
      });

      test('point inside Bremen returns true', () {
        // City center
        expect(viewModel.isWithinBremen(const LatLng(53.0793, 8.8017)), true);
        // Near Hauptbahnhof
        expect(viewModel.isWithinBremen(const LatLng(53.0833, 8.8142)), true);
        // Vegesack
        expect(viewModel.isWithinBremen(const LatLng(53.1667, 8.6167)), true);
      });

      test('point outside Bremen returns false', () {
        // Hamburg
        expect(viewModel.isWithinBremen(const LatLng(53.5511, 9.9937)), false);
        // Berlin
        expect(viewModel.isWithinBremen(const LatLng(52.5200, 13.4050)), false);
        // Too far south
        expect(viewModel.isWithinBremen(const LatLng(52.90, 8.8017)), false);
        // Too far north
        expect(viewModel.isWithinBremen(const LatLng(53.30, 8.8017)), false);
        // Too far west
        expect(viewModel.isWithinBremen(const LatLng(53.0793, 8.40)), false);
        // Too far east
        expect(viewModel.isWithinBremen(const LatLng(53.0793, 9.10)), false);
      });

      test('points on Bremen boundary are included', () {
        // Min latitude boundary
        expect(viewModel.isWithinBremen(const LatLng(52.96, 8.8017)), true);
        // Max latitude boundary
        expect(viewModel.isWithinBremen(const LatLng(53.22, 8.8017)), true);
        // Min longitude boundary
        expect(viewModel.isWithinBremen(const LatLng(53.0793, 8.48)), true);
        // Max longitude boundary
        expect(viewModel.isWithinBremen(const LatLng(53.0793, 9.01)), true);
      });
    });

    group('Initial state', () {
      test('selectedMarker is null initially', () {
        expect(viewModel.selectedMarker, isNull);
      });

      test('currentScore is null initially', () {
        expect(viewModel.currentScore, isNull);
      });

      test('isLoading is false initially', () {
        expect(viewModel.isLoading, false);
      });

      test('showSearch is false initially', () {
        expect(viewModel.showSearch, false);
      });

      test('showSlowLoadingMessage is false initially', () {
        expect(viewModel.showSlowLoadingMessage, false);
      });
    });

    group('toggleSearch', () {
      test('toggleSearch(true) sets showSearch to true', () {
        viewModel.toggleSearch(true);
        expect(viewModel.showSearch, true);
      });

      test('toggleSearch(false) sets showSearch to false', () {
        viewModel.toggleSearch(true);
        viewModel.toggleSearch(false);
        expect(viewModel.showSearch, false);
      });

      test('toggleSearch notifies listeners', () {
        var notified = false;
        viewModel.addListener(() => notified = true);
        viewModel.toggleSearch(true);
        expect(notified, true);
      });
    });

    group('clearError', () {
      test('clearError sets errorMessage to null', () {
        // We can't easily set an error, but we can call clearError
        viewModel.clearError();
        expect(viewModel.errorMessage, isNull);
      });

      test('clearError notifies listeners', () {
        var notified = false;
        viewModel.addListener(() => notified = true);
        viewModel.clearError();
        expect(notified, true);
      });
    });

    group('Constants', () {
      test('bremenCenter has correct coordinates', () {
        expect(MapViewModel.bremenCenter.latitude, 53.0793);
        expect(MapViewModel.bremenCenter.longitude, 8.8017);
      });

      test('Bremen bounding box is valid', () {
        expect(MapViewModel.bremenMinLat, lessThan(MapViewModel.bremenMaxLat));
        expect(MapViewModel.bremenMinLon, lessThan(MapViewModel.bremenMaxLon));
      });

      test('bremenCenter is within bounding box', () {
        expect(
          MapViewModel.bremenCenter.latitude,
          greaterThanOrEqualTo(MapViewModel.bremenMinLat),
        );
        expect(
          MapViewModel.bremenCenter.latitude,
          lessThanOrEqualTo(MapViewModel.bremenMaxLat),
        );
        expect(
          MapViewModel.bremenCenter.longitude,
          greaterThanOrEqualTo(MapViewModel.bremenMinLon),
        );
        expect(
          MapViewModel.bremenCenter.longitude,
          lessThanOrEqualTo(MapViewModel.bremenMaxLon),
        );
      });
    });

    group('onShowMessage callback', () {
      test('onShowMessage is null initially', () {
        expect(viewModel.onShowMessage, isNull);
      });

      test('onShowMessage can be set', () {
        String? receivedMessage;
        viewModel.onShowMessage = (message) => receivedMessage = message;
        viewModel.onShowMessage?.call('Test message');
        expect(receivedMessage, 'Test message');
      });
    });

    group('mapController', () {
      test('mapController is not null', () {
        expect(viewModel.mapController, isNotNull);
      });
    });
  });
}
