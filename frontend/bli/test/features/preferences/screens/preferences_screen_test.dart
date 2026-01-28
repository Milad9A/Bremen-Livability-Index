import 'package:bli/features/preferences/bloc/preferences_bloc.dart';
import 'package:bli/features/preferences/bloc/preferences_event.dart';
import 'package:bli/features/preferences/models/user_preferences.dart';
import 'package:bli/features/preferences/screens/preferences_screen.dart';
import 'package:bli/features/preferences/services/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

// Manual Mock for PreferencesService (recreated here for isolation)
class MockPreferencesService extends Fake implements PreferencesService {
  UserPreferences _localPrefs = UserPreferences.defaults;

  @override
  Future<UserPreferences> getLocalPreferences() async {
    return _localPrefs;
  }

  @override
  Future<void> saveLocalPreferences(UserPreferences preferences) async {
    _localPrefs = preferences;
  }
}

void main() {
  group('PreferencesScreen', () {
    late MockPreferencesService mockService;
    late PreferencesBloc bloc;

    setUp(() {
      mockService = MockPreferencesService();
      bloc = PreferencesBloc(preferencesService: mockService);
    });

    tearDown(() {
      bloc.close();
    });

    Future<void> pumpScreen(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: bloc,
            child: const PreferencesScreen(),
          ),
        ),
      );
      // Wait for initial load
      await tester.pumpAndSettle();
    }

    testWidgets('renders title and sections correctly', (tester) async {
      await pumpScreen(tester);

      expect(find.text('Score Preferences'), findsOneWidget);
      expect(find.text('Positive Factors'), findsOneWidget);
      expect(find.text('Parks & Trees'), findsOneWidget);

      // Scroll to find elements that might be off-screen
      final listFinder = find.byType(ListView);
      await tester.drag(listFinder, const Offset(0, -500));
      await tester.pumpAndSettle();

      expect(find.text('Penalty Factors'), findsOneWidget);
      expect(find.text('Traffic Safety'), findsOneWidget);
    });

    testWidgets('Reset button hidden by default', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Reset'), findsNothing);
    });

    testWidgets('Reset button shows when customized', (tester) async {
      // Customize a preference directly in the bloc first or via UI
      bloc.add(
        const UpdateFactor(factorKey: 'greenery', level: ImportanceLevel.high),
      );

      await pumpScreen(tester);
      await tester.pumpAndSettle(); // Wait for state update

      expect(find.text('Reset'), findsOneWidget);
    });

    testWidgets('Tapping Reset button resets preferences', (tester) async {
      // First customize
      bloc.add(
        const UpdateFactor(factorKey: 'greenery', level: ImportanceLevel.high),
      );
      await pumpScreen(tester);

      // Verify reset button is there
      final resetButton = find.text('Reset');
      expect(resetButton, findsOneWidget);

      // Tap it
      await tester.tap(resetButton);
      await tester.pumpAndSettle();

      // Verify reset button is gone (because state is now default)
      expect(find.text('Reset'), findsNothing);
      expect(bloc.state.preferences.greenery, ImportanceLevel.medium);
    });

    // Note: Testing SegmentedButton interactions can be tricky depending on how they are implemented.
    // We'll trust the deeper logic is covered by bloc tests and basic rendering here.
  });
}
