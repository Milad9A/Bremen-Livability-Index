import 'dart:convert';
import 'dart:typed_data';
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
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<AuthService>(), MockSpec<AuthBloc>()])
import 'auth_screen_test.mocks.dart';

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

  setUp(() {
    mockAuthBloc = MockAuthBloc();

    // Setup default state
    when(mockAuthBloc.state).thenReturn(const AuthState());
    when(
      mockAuthBloc.stream,
    ).thenAnswer((_) => Stream.value(const AuthState()));
  });

  Widget createWidgetUnderTest() {
    return DefaultAssetBundle(
      bundle: TestAssetBundle(),
      child: MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const AuthScreen(),
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
  });
}
