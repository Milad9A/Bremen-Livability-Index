import 'package:bli/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class PhoneAuthUnsupportedView extends StatelessWidget {
  final VoidCallback onBackPressed;

  const PhoneAuthUnsupportedView({super.key, required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone_disabled, size: 80, color: AppColors.greyMedium),
            const SizedBox(height: 24),
            const Text(
              'Phone Authentication Not Available',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Phone authentication is not supported on desktop platforms. Please use Google, GitHub, or guest sign-in instead.',
              style: TextStyle(fontSize: 16, color: AppColors.greyMedium),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onBackPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Choose Another Method',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
