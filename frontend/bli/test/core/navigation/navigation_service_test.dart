import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bli/core/navigation/navigation_service.dart';
import 'package:bli/features/auth/bloc/auth_bloc.dart';
import 'package:bli/features/auth/bloc/auth_event.dart';
import 'package:bli/features/auth/bloc/auth_state.dart';
import 'package:bli/features/auth/screens/auth_screen.dart';
import 'package:bli/features/auth/screens/email_auth_screen.dart';
import 'package:bli/features/map/bloc/map_bloc.dart';
import 'package:bli/features/map/screens/map_screen.dart';
import 'package:bli/features/preferences/bloc/preferences_bloc.dart';
import 'package:bli/features/preferences/bloc/preferences_event.dart';
import 'package:bli/features/preferences/bloc/preferences_state.dart';
import 'package:bli/features/preferences/models/user_preferences.dart';
import 'package:flutter_map/flutter_map.dart' hide MapEvent;
import 'package:latlong2/latlong.dart';

// Mocks
class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class MockMapBloc extends MockBloc<MapEvent, MapState> implements MapBloc {}

class MockPreferencesBloc extends MockBloc<PreferencesEvent, PreferencesState>
    implements PreferencesBloc {}

class MockMapController extends Mock implements MapController {}

class FakeAuthEvent extends Fake implements AuthEvent {}

class FakeAuthState extends Fake implements AuthState {}
// Sealed classes handled by concrete fallbacks or just not needed if we don't verify specific events.
// But bloc_test/mocktail usually wants registerFallbackValue for any event/state type if we use verify/when.

class TestNavigatorObserver extends NavigatorObserver {
  final List<String> pushedRoutes = [];
  final List<String> replacedRoutes = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name != null) {
      pushedRoutes.add(route.settings.name!);
    } else if (route is MaterialPageRoute) {
      pushedRoutes.add(route.runtimeType.toString());
    } else {
      pushedRoutes.add(route.runtimeType.toString());
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute?.settings.name != null) {
      replacedRoutes.add(newRoute!.settings.name!);
    } else if (newRoute != null) {
      replacedRoutes.add(newRoute.runtimeType.toString());
    }
  }
}

void main() {
  group('NavigationService', () {
    late TestNavigatorObserver testObserver;
    late MockAuthBloc mockAuthBloc;
    late MockMapBloc mockMapBloc;
    late MockPreferencesBloc mockPreferencesBloc;
    late MockMapController mockMapController;

    setUpAll(() {
      registerFallbackValue(FakeAuthEvent());
      registerFallbackValue(FakeAuthState());

      // Use concrete instances for sealed classes
      registerFallbackValue(const MapTapped(LatLng(0, 0)));
      registerFallbackValue(MapState.initial());
      registerFallbackValue(const LoadPreferences());
      registerFallbackValue(const PreferencesState());
    });

    setUp(() {
      testObserver = TestNavigatorObserver();
      mockAuthBloc = MockAuthBloc();
      mockMapBloc = MockMapBloc();
      mockPreferencesBloc = MockPreferencesBloc();
      mockMapController = MockMapController();

      // Stub default states
      when(() => mockAuthBloc.state).thenReturn(const AuthState());

      when(() => mockMapBloc.state).thenReturn(MapState.initial());
      when(() => mockMapBloc.mapController).thenReturn(mockMapController);

      when(() => mockPreferencesBloc.state).thenReturn(
        const PreferencesState(preferences: UserPreferences.defaults),
      );
    });

    Future<void> pumpNavigationTest(
      WidgetTester tester,
      void Function(BuildContext context) action,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: mockAuthBloc),
            BlocProvider<MapBloc>.value(value: mockMapBloc),
            BlocProvider<PreferencesBloc>.value(value: mockPreferencesBloc),
          ],
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () => action(context),
                    child: const Text('Navigate'),
                  ),
                );
              },
            ),
            navigatorObservers: [testObserver],
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      testObserver.pushedRoutes.clear();
      testObserver.replacedRoutes.clear();

      await tester.tap(find.text('Navigate'));
      // Use pump with duration instead of pumpAndSettle to avoid timeout on animated screens
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    }

    testWidgets('navigateToMap pushes MapScreen (replace=true)', (
      tester,
    ) async {
      await pumpNavigationTest(
        tester,
        (context) => NavigationService.navigateToMap(context, replace: true),
      );

      expect(find.byType(MapScreen), findsOneWidget);
      expect(testObserver.replacedRoutes.isNotEmpty, isTrue);
    });

    testWidgets('navigateToMap pushes MapScreen (replace=false)', (
      tester,
    ) async {
      await pumpNavigationTest(
        tester,
        (context) => NavigationService.navigateToMap(context, replace: false),
      );

      expect(find.byType(MapScreen), findsOneWidget);
      expect(testObserver.pushedRoutes.isNotEmpty, isTrue);
    });

    testWidgets('navigateToAuth pushes AuthScreen', (tester) async {
      await pumpNavigationTest(
        tester,
        (context) => NavigationService.navigateToAuth(context),
      );

      expect(find.byType(AuthScreen), findsOneWidget);
      expect(testObserver.pushedRoutes.isNotEmpty, isTrue);
    });

    testWidgets('navigateToEmailAuth pushes EmailAuthScreen', (tester) async {
      await pumpNavigationTest(
        tester,
        (context) => NavigationService.navigateToEmailAuth(context),
      );

      expect(find.byType(EmailAuthScreen), findsOneWidget);
      expect(testObserver.pushedRoutes.isNotEmpty, isTrue);
    });

    testWidgets('pop calls Navigator.pop', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [testObserver],
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const Scaffold(body: Text('Second Screen')),
                      ),
                    );
                  },
                  child: const Text('Push Second'),
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('Push Second'));
      await tester.pumpAndSettle();
      expect(find.text('Second Screen'), findsOneWidget);

      final BuildContext context = tester.element(find.text('Second Screen'));
      NavigationService.pop(context);
      await tester.pumpAndSettle();

      expect(find.text('Push Second'), findsOneWidget);
      expect(find.text('Second Screen'), findsNothing);
    });

    testWidgets('popToHome calls Navigator.pushNamedAndRemoveUntil', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          initialRoute: '/initial',
          routes: {
            '/': (context) => const Scaffold(body: Text('Home Screen')),
            '/initial': (context) => Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () => NavigationService.popToHome(context),
                    child: const Text('Go Home'),
                  ),
                );
              },
            ),
          },
          navigatorObservers: [testObserver],
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Go Home'), findsOneWidget);

      await tester.tap(find.text('Go Home'));
      await tester.pumpAndSettle();

      expect(find.text('Home Screen'), findsOneWidget);
      expect(find.text('Go Home'), findsNothing);
    });
  });
}
