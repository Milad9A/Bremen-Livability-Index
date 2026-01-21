import 'package:bli/core/theme/app_theme.dart';
import 'package:bli/features/auth/bloc/auth_bloc.dart';
import 'package:bli/features/auth/bloc/auth_event.dart';
import 'package:bli/features/auth/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GuestOptionButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const GuestOptionButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return TextButton(
          onPressed: state.isLoading
              ? null
              : onPressed ??
                    () {
                      context.read<AuthBloc>().add(
                        const GuestSignInRequested(),
                      );
                    },
          style: TextButton.styleFrom(
            foregroundColor: AppColors.greyDark,
            overlayColor: AppColors.primary.withValues(alpha: 0.1),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
          child: const Text('Continue as Guest'),
        );
      },
    );
  }
}
