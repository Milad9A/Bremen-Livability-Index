import 'package:bli/features/auth/bloc/auth_bloc.dart';
import 'package:bli/features/auth/bloc/auth_event.dart';
import 'package:bli/features/auth/bloc/auth_state.dart';
import 'package:bli/core/navigation/navigation_service.dart';
import 'package:bli/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bli/features/onboarding/widgets/start_screen_actions.dart';
import 'package:bli/features/onboarding/widgets/start_screen_title.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _textController;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    _textSlide = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 250));
    if (mounted) {
      _textController.forward();
    }
  }

  void _navigateToMap() {
    NavigationService.navigateToMap(context, replace: true);
  }

  void _navigateToAuth() {
    NavigationService.navigateToAuth(context);
  }

  void _continueAsGuest() {
    context.read<AuthBloc>().add(const GuestSignInRequested());
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.isAuthenticated != current.isAuthenticated,
      listener: (context, state) {
        if (state.isAuthenticated) {
          _navigateToMap();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Stack(
          children: [
            StartScreenTitle(textSlide: _textSlide, textOpacity: _textOpacity),
            Center(
              child: Image.asset(
                'assets/app_icon_no_background.png',
                width: 136,
                height: 136,
                fit: BoxFit.contain,
              ),
            ),
            StartScreenActions(
              textOpacity: _textOpacity,
              onLogin: _navigateToAuth,
              onContinueAsGuest: _continueAsGuest,
            ),
          ],
        ),
      ),
    );
  }
}
