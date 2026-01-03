import 'package:bli/widgets/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FloatingSearchBar', () {
    testWidgets('renders search icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FloatingSearchBar(onTap: () {})),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('shows placeholder text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FloatingSearchBar(onTap: () {})),
        ),
      );

      expect(find.text('Search for an address...'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FloatingSearchBar(onTap: () => tapped = true)),
        ),
      );

      await tester.tap(find.byType(FloatingSearchBar));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('contains GestureDetector', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FloatingSearchBar(onTap: () {})),
        ),
      );

      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('text field is read only', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FloatingSearchBar(onTap: () {})),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.readOnly, isTrue);
    });

    testWidgets('text field is ignored for pointer events', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FloatingSearchBar(onTap: () {})),
        ),
      );

      // Find the IgnorePointer that wraps the TextField (should be ignoring: true)
      final ignorePointers = tester.widgetList<IgnorePointer>(
        find.byType(IgnorePointer),
      );
      final ignoringTrue = ignorePointers.where((w) => w.ignoring == true);
      expect(ignoringTrue.isNotEmpty, isTrue);
    });

    testWidgets('has no border on text field', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FloatingSearchBar(onTap: () {})),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.border, InputBorder.none);
    });
  });
}
