import 'package:bli/core/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoadingOverlay', () {
    testWidgets('shows circular progress indicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LoadingOverlay(showSlowLoadingMessage: false)),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('hides slow loading message when false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LoadingOverlay(showSlowLoadingMessage: false)),
        ),
      );

      expect(find.text('Waking up server...'), findsNothing);
      expect(
        find.text(
          'The backend is starting up. This may take up to 50 seconds.',
        ),
        findsNothing,
      );
    });

    testWidgets('shows slow loading message when true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LoadingOverlay(showSlowLoadingMessage: true)),
        ),
      );

      expect(find.text('Waking up server...'), findsOneWidget);
      expect(
        find.text(
          'The backend is starting up. This may take up to 50 seconds.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows cloud icon when slow loading', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LoadingOverlay(showSlowLoadingMessage: true)),
        ),
      );

      expect(find.byIcon(Icons.cloud_upload_outlined), findsOneWidget);
    });

    testWidgets('is centered on screen', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LoadingOverlay(showSlowLoadingMessage: false)),
        ),
      );

      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('contains column layout', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LoadingOverlay(showSlowLoadingMessage: true)),
        ),
      );

      expect(find.byType(Column), findsWidgets);
    });
  });
}
