import 'package:bli/features/auth/bloc/auth_bloc.dart';
import 'package:bli/features/auth/bloc/auth_state.dart';
import 'package:bli/features/auth/screens/email_auth_screen.dart';
import 'package:bli/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<AuthService>(), MockSpec<AuthBloc>()])
import 'email_auth_screen_test.mocks.dart';

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();

    when(mockAuthBloc.state).thenReturn(const AuthState());
    when(
      mockAuthBloc.stream,
    ).thenAnswer((_) => Stream.value(const AuthState()));
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const EmailAuthScreen(),
      ),
    );
  }

  group('EmailAuthScreen', () {
    testWidgets('renders input view correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Sign in with Email'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget); // Email input
      expect(find.text('Send Magic Link'), findsOneWidget);
    });

    testWidgets('shows validation error for invalid email', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final button = find.text('Send Magic Link');
      await tester.tap(button);
      await tester.pump();

      expect(find.text('Please enter your email'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'invalid-email');
      await tester.tap(button);
      await tester.pump();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('renders sent view correctly', (tester) async {
      when(mockAuthBloc.state).thenReturn(
        const AuthState(emailLinkSent: true, pendingEmail: 'test@example.com'),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Check your inbox'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('responsiveness check', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 800));
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
  });
}
