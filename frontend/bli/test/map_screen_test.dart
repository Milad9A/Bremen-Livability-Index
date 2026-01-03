import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bli/screens/map_screen.dart';
import 'package:bli/viewmodels/map_viewmodel.dart';
import 'package:bli/widgets/floating_search_bar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';

void main() {
  group('MapScreen', () {
    testWidgets('renders FlutterMap', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MapScreen()));

      expect(find.byType(FlutterMap), findsOneWidget);
    });

    testWidgets('renders floating search bar initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: MapScreen()));

      expect(find.byType(FloatingSearchBar), findsOneWidget);
    });

    testWidgets('renders location reset button', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MapScreen()));

      expect(find.byIcon(Icons.my_location), findsOneWidget);
    });

    testWidgets('does not show score card initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: MapScreen()));

      // ScoreCard should not be visible when no location is selected
      expect(find.text('Livability Score'), findsNothing);
    });

    testWidgets('does not show error banner initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: MapScreen()));

      expect(find.byIcon(Icons.error_outline), findsNothing);
    });

    testWidgets('does not show loading overlay initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: MapScreen()));

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('tapping search bar area shows address search', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: MapScreen()));

      // Tap on the floating search bar
      await tester.tap(find.byType(FloatingSearchBar));
      await tester.pumpAndSettle();

      // FloatingSearchBar should be replaced with AddressSearchWidget
      expect(find.byType(FloatingSearchBar), findsNothing);
    });

    testWidgets('tapping reset button resets map', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MapScreen()));

      // Find and tap the reset button
      await tester.tap(find.byIcon(Icons.my_location));
      await tester.pumpAndSettle();

      // Map should still be visible (reset doesn't hide it)
      expect(find.byType(FlutterMap), findsOneWidget);
    });
  });

  group('MapScreen with Provider', () {
    testWidgets('MapScreen creates its own MapViewModel', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: MapScreen()));

      // The widget tree should contain a ChangeNotifierProvider
      expect(find.byType(ChangeNotifierProvider<MapViewModel>), findsOneWidget);
    });

    testWidgets('MapScreen renders Scaffold', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MapScreen()));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('MapScreen uses Stack for layering', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: MapScreen()));

      expect(find.byType(Stack), findsWidgets);
    });
  });
}
