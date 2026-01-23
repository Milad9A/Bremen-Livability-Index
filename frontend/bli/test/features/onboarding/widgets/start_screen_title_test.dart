import 'package:bli/features/onboarding/widgets/start_screen_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget() {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 400,
          height: 800,
          child: Stack(
            children: [
              StartScreenTitle(
                textSlide: const AlwaysStoppedAnimation(Offset.zero),
                textOpacity: const AlwaysStoppedAnimation(1.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  group('StartScreenTitle', () {
    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.byType(StartScreenTitle), findsOneWidget);
    });

    testWidgets('displays Bremen Livability Index text', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.textContaining('Bremen'), findsOneWidget);
      expect(find.textContaining('Livability'), findsOneWidget);
    });

    testWidgets('uses SlideTransition for animation', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.byType(SlideTransition), findsWidgets); // At least one
    });

    testWidgets('uses FadeTransition for opacity animation', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.byType(FadeTransition), findsWidgets); // At least one
    });

    testWidgets('uses Positioned for layout', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.byType(Positioned), findsWidgets); // At least one
    });

    testWidgets('is contained within widget tree', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(
        find.descendant(
          of: find.byType(Stack),
          matching: find.byType(StartScreenTitle),
        ),
        findsOneWidget,
      );
    });
  });
}
