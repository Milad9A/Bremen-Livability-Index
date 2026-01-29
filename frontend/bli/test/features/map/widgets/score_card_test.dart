import 'package:bli/core/theme/app_theme.dart';
import 'package:bli/features/map/models/enums.dart';
import 'package:bli/features/map/models/models.dart';
import 'package:bli/features/map/widgets/score_card_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Helper to create a LivabilityScore for testing
  LivabilityScore createTestScore({
    double score = 75.0,
    double baseScore = 40.0,
    String summary = 'Test summary',
    List<Factor>? factors,
  }) {
    return LivabilityScore(
      score: score,
      baseScore: baseScore,
      location: const Location(latitude: 53.0793, longitude: 8.8017),
      factors:
          factors ??
          [
            const Factor(
              factor: MetricCategory.greenery,
              value: 15.0,
              description: 'Many parks nearby',
              impact: 'positive',
            ),
            const Factor(
              factor: MetricCategory.trafficSafety,
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
            body: SingleChildScrollView(child: ScoreCardView(score: score)),
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
            body: SingleChildScrollView(child: ScoreCardView(score: score)),
          ),
        ),
      );

      // Expand the card to see summary
      await tester.tap(find.text('Livability Score'));
      await tester.pumpAndSettle();

      expect(find.text('Great location for families'), findsOneWidget);
    });

    testWidgets('displays all factors', (WidgetTester tester) async {
      final score = createTestScore();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: ScoreCardView(score: score)),
          ),
        ),
      );

      // Expand the card to see factors
      await tester.tap(find.text('Livability Score'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Positive Factors'), findsOneWidget);
      expect(find.textContaining('Negative Factors'), findsOneWidget);
      expect(find.textContaining('Many parks nearby'), findsOneWidget);
      expect(find.textContaining('Heavy traffic area'), findsOneWidget);
      expect(find.text('+15.0'), findsWidgets);
      expect(find.text('-10.0'), findsWidgets);
    });

    testWidgets('shows add_circle icon for positive impact (fallback)', (
      WidgetTester tester,
    ) async {
      final score = createTestScore(
        factors: [
          const Factor(
            factor: MetricCategory.unknown,
            value: 10.0,
            description: 'Positive unknown factor',
            impact: 'positive',
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: ScoreCardView(score: score)),
          ),
        ),
      );

      // Expand the card to see factor icons
      await tester.tap(find.text('Livability Score'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add_circle), findsWidgets);
    });

    testWidgets('shows remove_circle icon for negative impact (fallback)', (
      WidgetTester tester,
    ) async {
      final score = createTestScore(
        factors: [
          const Factor(
            factor: MetricCategory.unknown,
            value: -5.0,
            description: 'Negative unknown factor',
            impact: 'negative',
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: ScoreCardView(score: score)),
          ),
        ),
      );

      // Expand the card to see factor icons
      await tester.tap(find.text('Livability Score'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.remove_circle), findsWidgets);
    });
  });

  group('ScoreFactorItem Widget', () {
    testWidgets('displays factor with positive value', (
      WidgetTester tester,
    ) async {
      final factor = const Factor(
        factor: MetricCategory.greenery,
        value: 12.5,
        description: 'Many parks',
        impact: 'positive',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScoreFactorItem(factor: factor, nearbyFeatures: const {}),
          ),
        ),
      );

      expect(find.textContaining('Many parks'), findsOneWidget);
      expect(find.text('+12.5'), findsOneWidget);
      expect(find.byIcon(Icons.nature), findsOneWidget);
    });

    testWidgets('displays factor with negative value', (
      WidgetTester tester,
    ) async {
      final factor = const Factor(
        factor: MetricCategory.noiseSources,
        value: -8.0,
        description: 'Near highway',
        impact: 'negative',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScoreFactorItem(factor: factor, nearbyFeatures: const {}),
          ),
        ),
      );

      expect(find.text('-8.0'), findsOneWidget);
      expect(find.byIcon(Icons.volume_up), findsOneWidget);
    });

    testWidgets(
      'displays "No detailed features available" when features empty',
      (WidgetTester tester) async {
        final factor = const Factor(
          factor: MetricCategory.greenery,
          value: 10.0,
          description: 'Parks nearby',
          impact: 'positive',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScoreFactorItem(factor: factor, nearbyFeatures: const {}),
            ),
          ),
        );

        // Tap to expand the ExpansionTile
        await tester.tap(find.byType(ExpansionTile));
        await tester.pumpAndSettle();

        expect(find.text('No detailed features available.'), findsOneWidget);
      },
    );

    testWidgets('displays nearby features with distance', (
      WidgetTester tester,
    ) async {
      final factor = const Factor(
        factor: MetricCategory.greenery,
        value: 10.0,
        description: 'Parks nearby',
        impact: 'positive',
      );

      final nearbyFeatures = {
        'parks': [
          FeatureDetail(
            type: FeatureType.park,
            name: 'City Park',
            distance: 150.0,
            geometry: {
              'type': 'Point',
              'coordinates': [8.8, 53.0],
            },
          ),
        ],
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScoreFactorItem(
              factor: factor,
              nearbyFeatures: nearbyFeatures,
            ),
          ),
        ),
      );

      // Tap to expand the ExpansionTile
      await tester.tap(find.byType(ExpansionTile));
      await tester.pumpAndSettle();

      expect(find.textContaining('City Park'), findsOneWidget);
      expect(find.text('150m'), findsOneWidget);
    });
  });

  group('ScoreCard expand/collapse', () {
    testWidgets('starts collapsed by default', (WidgetTester tester) async {
      final score = createTestScore();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: ScoreCardView(score: score)),
          ),
        ),
      );

      // Card starts collapsed - "Positive Factors" should NOT be visible
      expect(find.text('Positive Factors'), findsNothing);
    });

    testWidgets('expands when tapped', (WidgetTester tester) async {
      final score = createTestScore();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: ScoreCardView(score: score)),
          ),
        ),
      );

      // Tap to expand
      await tester.tap(find.text('Livability Score'));
      await tester.pumpAndSettle();

      // After expanding, "Positive Factors" should be visible
      expect(find.text('Positive Factors'), findsOneWidget);
    });

    testWidgets('collapses again when tapped twice', (
      WidgetTester tester,
    ) async {
      final score = createTestScore();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: ScoreCardView(score: score)),
          ),
        ),
      );

      // Expand
      await tester.tap(find.text('Livability Score'));
      await tester.pumpAndSettle();
      expect(find.text('Positive Factors'), findsOneWidget);

      // Collapse again
      await tester.tap(find.text('Livability Score'));
      await tester.pumpAndSettle();
      expect(find.text('Positive Factors'), findsNothing);
    });
  });

  group('ScoreCard favorites', () {
    testWidgets('shows filled heart when isFavorite is true', (
      WidgetTester tester,
    ) async {
      final score = createTestScore();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ScoreCardView(
                score: score,
                isFavorite: true,
                onFavoriteToggle: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });

    testWidgets('shows outline heart when isFavorite is false', (
      WidgetTester tester,
    ) async {
      final score = createTestScore();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ScoreCardView(
                score: score,
                isFavorite: false,
                onFavoriteToggle: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets('calls onFavoriteToggle when favorite button tapped', (
      WidgetTester tester,
    ) async {
      final score = createTestScore();
      bool callbackInvoked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ScoreCardView(
                score: score,
                isFavorite: false,
                onFavoriteToggle: () {
                  callbackInvoked = true;
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pump();

      expect(callbackInvoked, isTrue);
    });

    testWidgets('hides favorite button when onFavoriteToggle is null', (
      WidgetTester tester,
    ) async {
      final score = createTestScore();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ScoreCardView(score: score, onFavoriteToggle: null),
            ),
          ),
        ),
      );

      // No favorite icons should be present
      expect(find.byIcon(Icons.favorite), findsNothing);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });
  });

  group('ScoreCard summary chips', () {
    testWidgets('displays base score chip with tooltip', (
      WidgetTester tester,
    ) async {
      final score = createTestScore(baseScore: 45.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: ScoreCardView(score: score)),
          ),
        ),
      );

      // Expand the card to see summary chips
      await tester.tap(find.text('Livability Score'));
      await tester.pumpAndSettle();

      expect(find.text('45'), findsOneWidget);
      // Verify Tooltip is present
      expect(find.byType(Tooltip), findsOneWidget);
    });

    testWidgets('displays positive and negative totals', (
      WidgetTester tester,
    ) async {
      final score = createTestScore();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: ScoreCardView(score: score)),
          ),
        ),
      );

      // Expand the card to see summary chips
      await tester.tap(find.text('Livability Score'));
      await tester.pumpAndSettle();

      // Default test score has +15.0 positive and -10.0 negative
      expect(find.text('+15.0'), findsWidgets);
      expect(find.text('-10.0'), findsWidgets);
    });

    testWidgets('displays factor count', (WidgetTester tester) async {
      final score = createTestScore();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: ScoreCardView(score: score)),
          ),
        ),
      );

      // Expand the card to see summary chips
      await tester.tap(find.text('Livability Score'));
      await tester.pumpAndSettle();

      expect(find.text('2 factors'), findsOneWidget);
    });
  });

  group('getScoreColor', () {
    test('returns high color for score >= 75', () {
      expect(getScoreColor(75.0), equals(AppColors.scoreHigh));
      expect(getScoreColor(100.0), equals(AppColors.scoreHigh));
      expect(getScoreColor(85.5), equals(AppColors.scoreHigh));
    });

    test('returns medium color for score >= 50 and < 75', () {
      expect(getScoreColor(50.0), equals(AppColors.scoreMedium));
      expect(getScoreColor(74.9), equals(AppColors.scoreMedium));
      expect(getScoreColor(60.0), equals(AppColors.scoreMedium));
    });

    test('returns low color for score < 50', () {
      expect(getScoreColor(49.9), equals(AppColors.scoreLow));
      expect(getScoreColor(0.0), equals(AppColors.scoreLow));
      expect(getScoreColor(25.0), equals(AppColors.scoreLow));
    });
  });
}
