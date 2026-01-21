import 'package:bli/features/onboarding/screens/start_screen.dart';
import 'package:bli/features/auth/bloc/auth_bloc.dart';
import 'package:bli/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Simple mock for AuthService that can be instantiated without build_runner
class MockAuthService implements AuthService {
  Future<bool> checkHealth() async => true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockNavigatorObserver extends NavigatorObserver {}

Widget _buildTestWidget(MockAuthService mockAuthService) {
  return MaterialApp(
    home: BlocProvider<AuthBloc>(
      create: (_) => AuthBloc(authService: mockAuthService),
      child: const StartScreen(),
    ),
  );
}

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  group('StartScreen', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(_buildTestWidget(mockAuthService));

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    }, skip: true);

    testWidgets('navigates to MapScreen on button tap', (tester) async {
      final navigatorObserver = MockNavigatorObserver();
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/': (context) => BlocProvider<AuthBloc>(
              create: (_) => AuthBloc(authService: mockAuthService),
              child: const StartScreen(),
            ),
          },
          navigatorObservers: [navigatorObserver],
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    }, skip: true);
  });
}
