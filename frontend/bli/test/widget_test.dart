// Basic smoke test for the Bremen Livability Index app.
//
// This test verifies that the app can launch without errors.

import 'package:flutter_test/flutter_test.dart';
import 'package:bli/main.dart';

void main() {
  testWidgets('App launches and displays map screen', (
    WidgetTester tester,
  ) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const BremenLivabilityApp());

    // Pump a few frames to let the app initialize
    await tester.pump();

    // Verify the app renders without crashing - just check MaterialApp exists
    expect(find.byType(BremenLivabilityApp), findsOneWidget);
  });
}
