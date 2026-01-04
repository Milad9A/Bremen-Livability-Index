// Basic smoke test for the Bremen Livability Index app.
//
// This test verifies that the app can launch without errors.

import 'package:flutter_test/flutter_test.dart';
import 'package:bli/main.dart';
import 'package:bli/features/onboarding/screens/start_screen.dart';

void main() {
  testWidgets('App launches and displays start screen', (
    WidgetTester tester,
  ) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const BremenLivabilityApp());

    // Pump a few frames to let the app initialize
    await tester.pump();

    // Verify the app renders without crashing
    expect(find.byType(BremenLivabilityApp), findsOneWidget);

    // Verify StartScreen is shown
    expect(find.byType(StartScreen), findsOneWidget);

    // Verify app title is displayed
    expect(find.text('Bremen Livability Index'), findsOneWidget);

    // Pump all remaining timers to avoid timer pending errors
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });
}
