import 'package:bli/features/map/widgets/map_control_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MapControlButtons', () {
    testWidgets('renders profile button with person icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MapControlButtons(onProfileTap: () {}, onResetTap: () {}),
          ),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('renders reset button with my_location icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MapControlButtons(onProfileTap: () {}, onResetTap: () {}),
          ),
        ),
      );

      expect(find.byIcon(Icons.my_location), findsOneWidget);
    });

    testWidgets('calls onProfileTap when profile button is tapped', (
      tester,
    ) async {
      bool profileTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MapControlButtons(
              onProfileTap: () => profileTapped = true,
              onResetTap: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      expect(profileTapped, isTrue);
    });

    testWidgets('calls onResetTap when reset button is tapped', (tester) async {
      bool resetTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MapControlButtons(
              onProfileTap: () {},
              onResetTap: () => resetTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.my_location));
      await tester.pumpAndSettle();

      expect(resetTapped, isTrue);
    });

    testWidgets('renders buttons in a Column', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MapControlButtons(onProfileTap: () {}, onResetTap: () {}),
          ),
        ),
      );

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('has two GestureDetector widgets', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MapControlButtons(onProfileTap: () {}, onResetTap: () {}),
          ),
        ),
      );

      final gestureDetectors = tester.widgetList<GestureDetector>(
        find.byType(GestureDetector),
      );
      expect(gestureDetectors.length, greaterThanOrEqualTo(2));
    });
    testWidgets('calls onSettingsTap when settings button is tapped', (
      tester,
    ) async {
      bool settingsTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MapControlButtons(
              onProfileTap: () {},
              onResetTap: () {},
              onSettingsTap: () => settingsTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.tune));
      await tester.pumpAndSettle();

      expect(settingsTapped, isTrue);
    });

    testWidgets('shows custom prefs indicator when true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MapControlButtons(
              onProfileTap: () {},
              onResetTap: () {},
              onSettingsTap: () {},
              hasCustomPrefs: true,
            ),
          ),
        ),
      );

      // find by decoration color AppColors.warning (which is usually orange/red)
      // or easier, look for the stack structure or simply the container size 12x12
      final indicator = find.byWidgetPredicate((widget) {
        return widget is Container &&
            widget.constraints?.minWidth == 12 &&
            widget.constraints?.minHeight == 12;
      });
      expect(indicator, findsOneWidget);
    });

    testWidgets('hides custom prefs indicator when false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MapControlButtons(
              onProfileTap: () {},
              onResetTap: () {},
              onSettingsTap: () {},
              hasCustomPrefs: false,
            ),
          ),
        ),
      );

      final indicator = find.byWidgetPredicate((widget) {
        return widget is Container &&
            widget.constraints?.minWidth == 12 &&
            widget.constraints?.minHeight == 12;
      });
      expect(indicator, findsNothing);
    });
  });
}
