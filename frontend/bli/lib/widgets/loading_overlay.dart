import 'package:bli/theme/app_theme.dart';
import 'package:bli/widgets/glass_container.dart';
import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool showSlowLoadingMessage;

  const LoadingOverlay({super.key, required this.showSlowLoadingMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GlassContainer(
            borderRadius: 100,
            padding: const EdgeInsets.all(20),
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          if (showSlowLoadingMessage) ...[
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: GlassContainer(
                opacity: 0.9,
                child: Column(
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 40,
                      color: AppColors.primaryDark,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Waking up server...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The backend is starting up. This may take up to 50 seconds.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.greyDark, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
