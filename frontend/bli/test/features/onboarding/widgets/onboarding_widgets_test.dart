import 'package:bli/features/auth/bloc/auth_bloc.dart';
import 'package:bli/features/auth/services/auth_service.dart';
import 'package:bli/features/onboarding/widgets/start_screen_actions.dart';
import 'package:bli/features/onboarding/widgets/start_screen_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<AuthService>()])
import 'onboarding_widgets_test.mocks.dart';

void main() {
  group('StartScreenTitle', () {
    testWidgets('displays Bremen Livability Index text', (tester) async {
      tester.view.physicalSize = const Size(400, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                StartScreenTitle(
                  textSlide: AlwaysStoppedAnimation(Offset.zero),
                  textOpacity: const AlwaysStoppedAnimation(1.0),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Bremen Livability Index'), findsOneWidget);
    });
  });

  group('StartScreenActions', () {
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
    });

    testWidgets('displays Log In button', (tester) async {
      tester.view.physicalSize = const Size(400, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<AuthBloc>(
              create: (_) => AuthBloc(authService: mockAuthService),
              child: Stack(
                children: [
                  StartScreenActions(
                    textOpacity: const AlwaysStoppedAnimation(1.0),
                    onLogin: () {},
                    onContinueAsGuest: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Log In'), findsOneWidget);
    });

    testWidgets('displays Continue as Guest button', (tester) async {
      tester.view.physicalSize = const Size(400, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<AuthBloc>(
              create: (_) => AuthBloc(authService: mockAuthService),
              child: Stack(
                children: [
                  StartScreenActions(
                    textOpacity: const AlwaysStoppedAnimation(1.0),
                    onLogin: () {},
                    onContinueAsGuest: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Continue as Guest'), findsOneWidget);
    });

    testWidgets('calls onLogin when Log In is tapped', (tester) async {
      tester.view.physicalSize = const Size(400, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      bool loginCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<AuthBloc>(
              create: (_) => AuthBloc(authService: mockAuthService),
              child: Stack(
                children: [
                  StartScreenActions(
                    textOpacity: const AlwaysStoppedAnimation(1.0),
                    onLogin: () => loginCalled = true,
                    onContinueAsGuest: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();

      expect(loginCalled, true);
    });

    testWidgets('calls onContinueAsGuest when button is tapped', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      bool guestCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<AuthBloc>(
              create: (_) => AuthBloc(authService: mockAuthService),
              child: Stack(
                children: [
                  StartScreenActions(
                    textOpacity: const AlwaysStoppedAnimation(1.0),
                    onLogin: () {},
                    onContinueAsGuest: () => guestCalled = true,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Continue as Guest'));
      await tester.pumpAndSettle();

      expect(guestCalled, true);
    });
  });
}
