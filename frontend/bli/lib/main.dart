import 'package:bli/features/auth/bloc/auth_bloc.dart';
import 'package:bli/features/auth/bloc/auth_event.dart';
import 'package:bli/features/auth/bloc/auth_state.dart';
import 'package:bli/features/auth/services/auth_service.dart';
import 'package:bli/features/onboarding/screens/start_screen.dart';
import 'package:bli/core/theme/app_theme.dart';
import 'package:bli/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bli/core/services/deep_link_service.dart';

import 'package:bli/features/favorites/bloc/favorites_bloc.dart';
import 'package:bli/features/favorites/bloc/favorites_event.dart';
import 'package:bli/features/favorites/services/favorites_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const BremenLivabilityApp());
}

class BremenLivabilityApp extends StatefulWidget {
  const BremenLivabilityApp({super.key});

  @override
  State<BremenLivabilityApp> createState() => _BremenLivabilityAppState();
}

class _BremenLivabilityAppState extends State<BremenLivabilityApp> {
  late AuthService _authService;
  late AuthBloc _authBloc;
  late FavoritesService _favoritesService;
  late FavoritesBloc _favoritesBloc;
  late DeepLinkService _deepLinkService;

  @override
  void initState() {
    super.initState();

    _authService = AuthService();
    _favoritesService = FavoritesService();

    _authBloc = AuthBloc(authService: _authService);
    _favoritesBloc = FavoritesBloc(favoritesService: _favoritesService);

    _authBloc.add(const AuthCheckRequested());

    _deepLinkService = DeepLinkService(
      authBloc: _authBloc,
      authService: _authService,
    )..init();
  }

  @override
  void dispose() {
    _deepLinkService.dispose();
    _favoritesBloc.close();
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider.value(value: _favoritesBloc),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        bloc: _authBloc,
        listenWhen: (previous, current) =>
            previous.user?.id != current.user?.id,
        listener: (context, state) {
          if (state.isAuthenticated && !state.isGuest) {
            _favoritesBloc.add(
              FavoritesEvent.loadFavoritesRequested(state.user!.id),
            );
          } else {
            _favoritesBloc.add(const FavoritesEvent.clearFavorites());
          }
        },
        child: MaterialApp(
          title: 'Bremen Livability Index',
          theme: AppTheme.lightTheme,
          initialRoute: '/',
          routes: {'/': (context) => const StartScreen()},
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
