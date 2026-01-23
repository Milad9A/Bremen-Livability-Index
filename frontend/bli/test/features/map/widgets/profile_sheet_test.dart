import 'package:bli/core/services/api_service.dart';
import 'package:bli/features/auth/bloc/auth_bloc.dart';
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

  Widget buildTestWidget() {
    final authBloc = AuthBloc(authService: mockAuthService);
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

    testWidgets('displays User text for unauthenticated state', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      // Profile sheet should show 'User' for null user
      expect(find.text('User'), findsOneWidget);
    });

    testWidgets('renders CircleAvatar', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('shows person icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('has Container with BoxDecoration', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Find the Container and verify its decoration
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.decoration, isA<BoxDecoration>());
    });

    testWidgets('does not show Saved Places button for unauthenticated user', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      // No user logged in, should not show Saved Places
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
  });
}
