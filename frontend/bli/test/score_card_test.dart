import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bli/widgets/score_card.dart';
import 'package:bli/services/api_service.dart';

void main() {
  // Helper to create a LivabilityScore for testing
  LivabilityScore createTestScore({
    double score = 75.0,
    String summary = 'Test summary',
    List<Factor>? factors,
  }) {
    return LivabilityScore(
      score: score,
      location: Location(latitude: 53.0793, longitude: 8.8017),
      factors:
          factors ??
          [
            Factor(
              factor: 'Green Spaces',
              value: 15.0,
              description: 'Many parks nearby',
              impact: 'positive',
            ),
            Factor(
              factor: 'Traffic',
              value: -10.0,
              description: 'Heavy traffic area',
              impact: 'negative',
            ),
          ],
      nearbyFeatures: {},
      summary: summary,
    );
  }

  group('ScoreCard Widget', () {
    testWidgets('displays score value correctly', (WidgetTester tester) async {
      final score = createTestScore(score: 82.5);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: ScoreCard(score: score)),
          ),
        ),
      );

      expect(find.text('82.5/100'), findsOneWidget);
      expect(find.text('Livability Score'), findsOneWidget);
    });

    testWidgets('displays summary text', (WidgetTester tester) async {
      final score = createTestScore(summary: 'Great location for families');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: ScoreCard(score: score)),
          ),
        ),
      );

      expect(find.text('Great location for families'), findsOneWidget);
    });

    testWidgets('displays all factors', (WidgetTester tester) async {
      final score = createTestScore();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: ScoreCard(score: score)),
          ),
        ),
      );

      expect(find.textContaining('Positive Factors'), findsOneWidget);
      expect(find.textContaining('Negative Factors'), findsOneWidget);
      expect(find.textContaining('Green Spaces'), findsOneWidget);
      expect(find.textContaining('Traffic'), findsOneWidget);
      expect(find.text('+15.0'), findsWidgets);
      expect(find.text('-10.0'), findsWidgets);
    });

    testWidgets('shows add_circle icon for positive impact', (
      WidgetTester tester,
    ) async {
      final score = createTestScore(
        factors: [
          Factor(
            factor: 'Parks',
            value: 10.0,
            description: 'Close to parks',
            impact: 'positive',
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: ScoreCard(score: score)),
          ),
        ),
      );

      expect(find.byIcon(Icons.add_circle), findsWidgets);
    });

    testWidgets('shows remove_circle icon for negative impact', (
      WidgetTester tester,
    ) async {
      final score = createTestScore(
        factors: [
          Factor(
            factor: 'Noise',
            value: -5.0,
            description: 'Noisy area',
            impact: 'negative',
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: ScoreCard(score: score)),
          ),
        ),
      );

      expect(find.byIcon(Icons.remove_circle), findsWidgets);
    });
  });

  group('ScoreFactorItem Widget', () {
    testWidgets('displays factor with positive value', (
      WidgetTester tester,
    ) async {
      final factor = Factor(
        factor: 'Green Spaces',
        value: 12.5,
        description: 'Many parks',
        impact: 'positive',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ScoreFactorItem(factor: factor)),
        ),
      );

      expect(find.textContaining('Green Spaces'), findsOneWidget);
      expect(find.textContaining('Many parks'), findsOneWidget);
      expect(find.text('+12.5'), findsOneWidget);
      expect(find.byIcon(Icons.add_circle), findsOneWidget);
    });

    testWidgets('displays factor with negative value', (
      WidgetTester tester,
    ) async {
      final factor = Factor(
        factor: 'Noise Sources',
        value: -8.0,
        description: 'Near highway',
        impact: 'negative',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ScoreFactorItem(factor: factor)),
        ),
      );

      expect(find.text('-8.0'), findsOneWidget);
      expect(find.byIcon(Icons.volume_up), findsOneWidget);
    });
  });
}
