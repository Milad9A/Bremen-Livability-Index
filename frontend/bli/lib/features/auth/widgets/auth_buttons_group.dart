import 'package:bli/core/theme/app_theme.dart';
import 'package:bli/features/auth/bloc/auth_bloc.dart';
import 'package:bli/features/auth/bloc/auth_event.dart';
import 'package:bli/features/auth/bloc/auth_state.dart';
import 'package:bli/features/auth/models/user.dart';
import 'package:bli/features/auth/widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthButtonsGroup extends StatelessWidget {
  final VoidCallback onEmailTap;

  const AuthButtonsGroup({super.key, required this.onEmailTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Column(
          children: [
            AuthButton.google(
              onPressed: state.isLoading
                  ? null
                  : () {
                      context.read<AuthBloc>().add(
                        const GoogleSignInRequested(),
                      );
                    },
              isLoading: state.loadingProvider == AppAuthProvider.google,
            ),
            const SizedBox(height: 12),
            AuthButton.github(
              onPressed: state.isLoading
                  ? null
                  : () {
                      context.read<AuthBloc>().add(
                        const GitHubSignInRequested(),
                      );
                    },
              isLoading: state.loadingProvider == AppAuthProvider.github,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: Divider(color: AppColors.greyLight)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'or',
                    style: TextStyle(color: AppColors.greyMedium, fontSize: 14),
                  ),
                ),
                Expanded(child: Divider(color: AppColors.greyLight)),
              ],
            ),
            const SizedBox(height: 12),
            AuthButton.email(
              onPressed: state.isLoading ? null : onEmailTap,
              isLoading: state.loadingProvider == AppAuthProvider.email,
            ),
          ],
        );
      },
    );
  }
}
