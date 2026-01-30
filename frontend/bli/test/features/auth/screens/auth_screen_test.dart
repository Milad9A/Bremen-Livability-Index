import 'dart:convert';
import 'package:bli/features/auth/bloc/auth_bloc.dart';
import 'package:bli/features/auth/bloc/auth_state.dart';
import 'package:bli/features/auth/screens/auth_screen.dart';
import 'package:bli/features/auth/services/auth_service.dart';
import 'package:bli/features/auth/widgets/auth_buttons_group.dart';
import 'package:bli/features/auth/widgets/guest_option_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bli/features/auth/bloc/auth_event.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bli/features/auth/models/user.dart'; // For User model
import 'package:bloc_test/bloc_test.dart'; // For whenListen

@GenerateNiceMocks([MockSpec<AuthService>(), MockSpec<AuthBloc>()])
import 'auth_screen_test.mocks.dart';

class TestNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> pushedRoutes = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedRoutes.add(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) pushedRoutes.add(newRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    return '';
  }

  @override
  Future<ByteData> load(String key) async {
    if (key == 'AssetManifest.bin') {
      final ByteData? data = const StandardMessageCodec().encodeMessage(
        <dynamic, dynamic>{},
      );
      return data ?? ByteData(0);
    }
    if (key == 'AssetManifest.json') {
      return ByteData.view(Uint8List.fromList(utf8.encode('{}')).buffer);
    }
    if (key == 'FontManifest.json') {
      return ByteData.view(Uint8List.fromList(utf8.encode('[]')).buffer);
    }

    final Uint8List kTransparentImage = Uint8List.fromList(<int>[
      0x89,
      0x50,
      0x4E,
      0x47,
      0x0D,
      0x0A,
      0x1A,
      0x0A,
      0x00,
      0x00,
      0x00,
      0x0D,
      0x49,
      0x48,
      0x44,
      0x52,
      0x00,
      0x00,
      0x00,
      0x01,
      0x00,
      0x00,
      0x00,
      0x01,
      0x08,
      0x06,
      0x00,
      0x00,
      0x00,
      0x1F,
      0x15,
      0xC4,
      0x89,
      0x00,
      0x00,
      0x00,
      0x0A,
      0x49,
      0x44,
      0x41,
      0x54,
      0x78,
      0x9C,
      0x63,
      0x00,
      0x01,
      0x00,
      0x00,
      0x05,
      0x00,
      0x01,
      0x0D,
      0x0A,
      0x2D,
      0xB4,
      0x00,
      0x00,
      0x00,
      0x00,
      0x49,
      0x45,
      0x4E,
      0x44,
      0xAE,
      0x42,
      0x60,
      0x82,
    ]);
    return ByteData.view(kTransparentImage.buffer);
  }
}

void main() {
  late MockAuthBloc mockAuthBloc;
  late TestNavigatorObserver mockObserver;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockObserver = TestNavigatorObserver(); // No registerFallbackValue needed

    // Setup default state
    when(mockAuthBloc.state).thenReturn(const AuthState());
    when(
      mockAuthBloc.stream,
    ).thenAnswer((_) => Stream.value(const AuthState()));
  });

  Widget createWidgetUnderTest() {
    return DefaultAssetBundle(
      bundle: TestAssetBundle(),
      child: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: MaterialApp(
          navigatorObservers: [mockObserver],
          routes: {
            '/map': (_) => const Scaffold(body: Text('Map Screen')),
            '/email-auth': (_) =>
                const Scaffold(body: Text('Email Auth Screen')),
          },
          home: const AuthScreen(),
        ),
      ),
    );
  }

  group('AuthScreen', () {
    testWidgets('renders correctly', (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 1200));
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(AuthScreen), findsOneWidget);
      expect(find.byType(AuthButtonsGroup), findsOneWidget);
      expect(find.byType(GuestOptionButton), findsOneWidget);

      // Check for responsiveness constraints
      // On a small screen
      await tester.binding.setSurfaceSize(const Size(600, 800));
      await tester.pumpWidget(createWidgetUnderTest());

      bool foundConstraint = false;
      final constrainedBoxes = tester.widgetList<ConstrainedBox>(
        find.byType(ConstrainedBox),
      );
      for (final box in constrainedBoxes) {
        if (box.constraints.maxWidth == 600) {
          foundConstraint = true;
          break;
        }
      }
      expect(
        foundConstraint,
        isTrue,
        reason: 'Should find a ConstrainedBox with maxWidth 600',
      );
    });
    testWidgets('triggers signInAnonymously when guest button tapped', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byType(GuestOptionButton));
      await tester.pump();

      verify(
        mockAuthBloc.add(const AuthEvent.guestSignInRequested()),
      ).called(1);
    });

    testWidgets('triggers googleSignInRequested when google button tapped', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Google button is usually in AuthButtonsGroup and has 'Google' text or similar key
      // Assuming AuthButtonsGroup has generic buttons, we look for text "Google"
      expect(find.text('Continue with Google'), findsOneWidget);

      await tester.tap(find.text('Continue with Google'));
      await tester.pump();

      verify(
        mockAuthBloc.add(const AuthEvent.googleSignInRequested()),
      ).called(1);
    });

    testWidgets('triggers gitHubSignInRequested when github button tapped', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Continue with GitHub'), findsOneWidget);

      await tester.tap(find.text('Continue with GitHub'));
      await tester.pump();

      verify(
        mockAuthBloc.add(const AuthEvent.gitHubSignInRequested()),
      ).called(1);
    });

    testWidgets('shows error snackbar on error', (tester) async {
      when(mockAuthBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          const AuthState(),
          const AuthState(error: 'Login Failed'),
        ]),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(); // trigger listener
      await tester.pump(); // animate snackbar

      expect(find.text('Login Failed'), findsOneWidget);
    });

    testWidgets('navigates to email auth when email button tapped', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // "Continue with Email" text expected
      expect(find.text('Continue with Email'), findsOneWidget);

      await tester.tap(find.text('Continue with Email'));
      await tester.pumpAndSettle();

      expect(mockObserver.pushedRoutes.isNotEmpty, isTrue);
      final pushedRoute = mockObserver.pushedRoutes.last;
      expect(pushedRoute, isA<MaterialPageRoute>());
    });
  });
}
