import 'package:bli/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

extension MessageSnackBarX on ScaffoldMessengerState {
  void showMessageSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: AppColors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.primaryDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: duration,
      ),
    );
  }
}
