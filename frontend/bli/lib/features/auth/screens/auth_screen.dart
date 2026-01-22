import 'package:bli/core/theme/app_theme.dart';
import 'package:bli/features/auth/bloc/auth_bloc.dart';
import 'package:bli/features/auth/bloc/auth_state.dart';
import 'package:bli/features/auth/widgets/auth_header.dart';
import 'package:bli/features/auth/widgets/auth_buttons_group.dart';
import 'package:bli/features/auth/widgets/guest_option_button.dart';
import 'package:bli/core/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  void _navigateToMap(BuildContext context) {
    NavigationService.navigateToMap(context, replace: true);
  }

  void _navigateToEmailAuth(BuildContext context) {
    NavigationService.navigateToEmailAuth(context);
  }

  void _navigateToPhoneAuth(BuildContext context) {
    NavigationService.navigateToPhoneAuth(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isAuthenticated) {
            _navigateToMap(context);
          }
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Spacer(flex: 1),
                    const AuthHeader(),
                    const Spacer(flex: 1),
                    AuthButtonsGroup(
                      onEmailTap: () => _navigateToEmailAuth(context),
                      onPhoneTap: () => _navigateToPhoneAuth(context),
                    ),
                    const SizedBox(height: 24),
                    const GuestOptionButton(),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
