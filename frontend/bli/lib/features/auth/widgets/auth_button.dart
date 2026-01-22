import 'package:bli/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AuthButton extends StatelessWidget {
  final String label;
  final Widget? icon;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AuthButton({
    super.key,
    required this.label,
    this.icon,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    this.onPressed,
    this.isLoading = false,
  });

  factory AuthButton.google({VoidCallback? onPressed, bool isLoading = false}) {
    return AuthButton(
      label: 'Continue with Google',
      icon: Image.asset('assets/google_logo.png', width: 20, height: 20),
      backgroundColor: AppColors.white,
      textColor: const Color(0xFF1F1F1F),
      borderColor: const Color(0xFFDADCE0),
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }

  factory AuthButton.github({VoidCallback? onPressed, bool isLoading = false}) {
    return AuthButton(
      label: 'Continue with GitHub',
      icon: const FaIcon(
        FontAwesomeIcons.github,
        size: 20,
        color: AppColors.white,
      ),
      backgroundColor: const Color(0xFF24292F),
      textColor: AppColors.white,
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }

  factory AuthButton.email({VoidCallback? onPressed, bool isLoading = false}) {
    return AuthButton(
      label: 'Continue with Email',
      icon: const Icon(Icons.email_outlined, size: 20),
      backgroundColor: AppColors.transparent,
      textColor: AppColors.primary,
      borderColor: AppColors.primary,
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: borderColor != null ? 0 : 1,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: 1)
                : BorderSide.none,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[icon!, const SizedBox(width: 12)],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
