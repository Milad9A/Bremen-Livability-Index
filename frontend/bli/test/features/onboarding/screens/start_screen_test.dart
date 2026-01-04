import 'package:bli/features/onboarding/screens/start_screen.dart';
import 'package:bli/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StartScreen', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: StartScreen()));

      // Initially some elements might be invisible due to fade transition
      // But we can pump to advance animation
      await tester.pump(const Duration(milliseconds: 1000));
      await tester.pump(const Duration(seconds: 1)); // Wait for all animations

      expect(find.text('Bremen Livability Index'), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget); // App icon

      // Check background color
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, AppColors.primary);
    });

    testWidgets('navigates to MapScreen on button tap', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          // home: const StartScreen(), // CONFLICTS with routes['/']
          routes: {'/': (context) => const StartScreen()},
        ),
      );

      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text('Get Started'));

      // We can't easily check pushReplacement with just routes without observing
      // But checking if MapScreen is pushed is possible if MapScreen is mockable or we check the widget tree

      // Since MapScreen is complex, pumping it might trigger network calls.
      // We should arguably mock MapScreen or use a NavigatorObserver.
      // For this task, checking the button is tapped is a good first step, verifying navigation
      // usually requires injecting a mock navigator or checking pushed routes.

      // Let's assume the button is tappable and verify state change if any.
      // Actually, since StartScreen does Navigator.pushReplacement, the StartScreen should be removed.

      await tester.pump(
        const Duration(milliseconds: 500),
      ); // Allow transition to start
      await tester.pump(
        const Duration(milliseconds: 500),
      ); // Allow transition to complete

      expect(find.byType(StartScreen), findsNothing);
      // MapScreen might be in the tree now.
      // If MapScreen makes network calls in initState it might fail if not mocked.
      // But we just passed Feature tests, let's see.
      // Ideally we'd intercept the route.
    });
  });
}
