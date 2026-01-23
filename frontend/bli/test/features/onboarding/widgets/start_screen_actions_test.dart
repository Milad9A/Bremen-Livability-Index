import 'package:bli/features/auth/bloc/auth_bloc.dart';
import 'package:bli/features/auth/bloc/auth_state.dart';
import 'package:bli/features/auth/services/auth_service.dart';
import 'package:bli/features/onboarding/widgets/start_screen_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock AuthService
class MockAuthService implements AuthService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  Widget buildTestWidget({
    VoidCallback? onLogin,
    VoidCallback? onContinueAsGuest,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 400,
          height: 800,
          child: Stack(
            children: [
              BlocProvider<AuthBloc>(
                create: (_) => AuthBloc(authService: mockAuthService),
                child: StartScreenActions(
                  textOpacity: const AlwaysStoppedAnimation(1.0),
                  onLogin: onLogin ?? () {},
                  onContinueAsGuest: onContinueAsGuest ?? () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  group('StartScreenActions', () {
    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.byType(StartScreenActions), findsOneWidget);
    });

    testWidgets('displays Log In button', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('Log In'), findsOneWidget);
    });

    testWidgets('displays Continue as Guest button', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('Continue as Guest'), findsOneWidget);
    });

    testWidgets('has ElevatedButton for Log In', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('has OutlinedButton for Continue as Guest', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('calls onLogin when Log In button is tapped', (tester) async {
      bool loginCalled = false;

      await tester.pumpWidget(
        buildTestWidget(onLogin: () => loginCalled = true),
      );

      await tester.tap(find.text('Log In'));
      await tester.pump();

      expect(loginCalled, isTrue);
    });

    testWidgets('calls onContinueAsGuest when Continue as Guest is tapped', (
      tester,
    ) async {
      bool guestCalled = false;

      await tester.pumpWidget(
        buildTestWidget(onContinueAsGuest: () => guestCalled = true),
      );

      await tester.tap(find.text('Continue as Guest'));
      await tester.pump();

      expect(guestCalled, isTrue);
    });

    testWidgets('uses FadeTransition for content', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.byType(FadeTransition), findsWidgets);
    });

    testWidgets('has BlocBuilder for loading state', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.byType(BlocBuilder<AuthBloc, AuthState>), findsOneWidget);
    });
  });
}
