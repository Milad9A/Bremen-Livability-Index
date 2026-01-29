import 'package:bli/core/services/api_service.dart';
import 'package:bli/features/auth/bloc/auth_bloc.dart';
import 'package:bli/features/auth/bloc/auth_state.dart';
import 'package:bli/features/auth/models/user.dart';
import 'package:bli/features/auth/services/auth_service.dart';
import 'package:bli/features/map/bloc/map_bloc.dart';
import 'package:bli/features/map/widgets/profile_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

// Simple mock for AuthService
class MockAuthService implements AuthService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// Simple mock for ApiService with required checkHealth method
class MockApiService implements ApiService {
  @override
  Future<bool> checkHealth() async => true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// Testable AuthBloc that can be initialized with a specific state
class TestableAuthBloc extends AuthBloc {
  final AuthState _initialState;

  TestableAuthBloc({required super.authService, AuthState? initialState})
    : _initialState = initialState ?? const AuthState();

  @override
  AuthState get state => _initialState;
}

void main() {
  late MockAuthService mockAuthService;
  late MockApiService mockApiService;
  late MapBloc mapBloc;

  setUp(() {
    mockAuthService = MockAuthService();
    mockApiService = MockApiService();
    mapBloc = MapBloc(apiService: mockApiService);
  });

  tearDown(() {
    mapBloc.close();
  });

  Widget buildTestWidget({AuthState? authState}) {
    final authBloc = TestableAuthBloc(
      authService: mockAuthService,
      initialState: authState,
    );
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: authBloc),
          BlocProvider<MapBloc>.value(value: mapBloc),
        ],
        child: const Scaffold(body: ProfileSheet()),
      ),
    );
  }

  group('ProfileSheet', () {
    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byType(ProfileSheet), findsOneWidget);
    });

    testWidgets('displays User text for null user state', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(authState: const AuthState(user: null)),
      );
      await tester.pump();

      expect(find.text('User'), findsOneWidget);
    });

    testWidgets('renders CircleAvatar', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('shows person icon for null user', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(authState: const AuthState(user: null)),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('has Container with BoxDecoration', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.decoration, isA<BoxDecoration>());
    });

    testWidgets('does not show Saved Places button for null user', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(authState: const AuthState(user: null)),
      );

      expect(find.text('Saved Places'), findsNothing);
    });

    testWidgets('shows Column layout', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('shows logout icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byIcon(Icons.logout), findsOneWidget);
    });

    testWidgets('displays displayName for authenticated user', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          authState: AuthState(
            user: const AppUser(
              id: 'user-123',
              displayName: 'John Doe',
              email: 'john@example.com',
              provider: AppAuthProvider.google,
              isAnonymous: false,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('displays email for authenticated user', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          authState: AuthState(
            user: const AppUser(
              id: 'user-123',
              displayName: 'John Doe',
              email: 'john@example.com',
              provider: AppAuthProvider.google,
              isAnonymous: false,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('john@example.com'), findsOneWidget);
    });

    testWidgets('displays Guest User for anonymous user', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(authState: AuthState(user: AppUser.guest())),
      );
      await tester.pump();

      expect(find.text('Guest User'), findsOneWidget);
    });

    testWidgets('shows person_outline icon for guest user', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(authState: AuthState(user: AppUser.guest())),
      );
      await tester.pump();

      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('shows sign-in hint for guest user', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(authState: AuthState(user: AppUser.guest())),
      );
      await tester.pump();

      expect(
        find.text('Sign in with an account to save your favorites'),
        findsOneWidget,
      );
    });

    testWidgets('shows Saved Places button for authenticated user', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          authState: AuthState(
            user: const AppUser(
              id: 'user-123',
              provider: AppAuthProvider.google,
              isAnonymous: false,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Saved Places'), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('hides Saved Places button for guest user', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(authState: AuthState(user: AppUser.guest())),
      );
      await tester.pump();

      expect(find.text('Saved Places'), findsNothing);
    });

    testWidgets('shows Sign In with Account for guest user', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(authState: AuthState(user: AppUser.guest())),
      );
      await tester.pump();

      expect(find.text('Sign In with Account'), findsOneWidget);
    });

    testWidgets('shows Sign Out for authenticated user', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          authState: AuthState(
            user: const AppUser(
              id: 'user-123',
              provider: AppAuthProvider.google,
              isAnonymous: false,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Sign Out'), findsOneWidget);
    });

    testWidgets(
      'OutlinedButton present for Saved Places and Score Preferences',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            authState: AuthState(
              user: const AppUser(
                id: 'user-123',
                provider: AppAuthProvider.google,
                isAnonymous: false,
              ),
            ),
          ),
        );
        await tester.pump();

        // Now we have 2 OutlinedButtons: Saved Places + Score Preferences
        expect(find.byType(OutlinedButton), findsNWidgets(2));
      },
    );

    testWidgets('shows Score Preferences button for all users', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(authState: AuthState(user: AppUser.guest())),
      );
      await tester.pump();

      expect(find.text('Score Preferences'), findsOneWidget);
      expect(find.byIcon(Icons.tune), findsOneWidget);
    });

    testWidgets('shows Score Preferences button for authenticated user', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          authState: AuthState(
            user: const AppUser(
              id: 'user-123',
              provider: AppAuthProvider.google,
              isAnonymous: false,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Score Preferences'), findsOneWidget);
    });

    testWidgets('guest user has only 1 OutlinedButton (Score Preferences)', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(authState: AuthState(user: AppUser.guest())),
      );
      await tester.pump();

      // Guest users only see Score Preferences (no Saved Places)
      expect(find.byType(OutlinedButton), findsOneWidget);
    });
  });
}
