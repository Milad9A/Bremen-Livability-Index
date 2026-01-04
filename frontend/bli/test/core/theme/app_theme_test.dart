import 'package:bli/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme', () {
    test('lightTheme should have correct primary properties', () {
      final theme = AppTheme.lightTheme;

      expect(theme.primaryColor, AppColors.primary);
      expect(theme.scaffoldBackgroundColor, AppColors.white);
      expect(theme.useMaterial3, true);
    });

    test('AppColors should have correct values', () {
      expect(AppColors.primary, Colors.teal);
      expect(AppColors.white, Colors.white);
      expect(AppColors.error, Colors.red[900]);
    });

    test('AppTextStyles should have correct values', () {
      expect(AppTextStyles.heading.fontSize, 24);
      expect(AppTextStyles.heading.fontWeight, FontWeight.bold);

      expect(AppTextStyles.subheading.fontSize, 18);
      expect(AppTextStyles.subheading.fontWeight, FontWeight.w600);

      expect(AppTextStyles.body.fontSize, 16);
      expect(AppTextStyles.caption.fontSize, 12);
    });
  });
}
