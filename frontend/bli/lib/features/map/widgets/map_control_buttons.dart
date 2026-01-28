import 'package:bli/core/theme/app_theme.dart';
import 'package:bli/core/widgets/glass_container.dart';
import 'package:flutter/material.dart';

class MapControlButtons extends StatelessWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onResetTap;
  final VoidCallback? onSettingsTap;
  final bool hasCustomPrefs;

  const MapControlButtons({
    super.key,
    required this.onProfileTap,
    required this.onResetTap,
    this.onSettingsTap,
    this.hasCustomPrefs = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onProfileTap,
          child: GlassContainer(
            borderRadius: 30,
            padding: const EdgeInsets.all(14),
            child: Icon(Icons.person, color: AppColors.primaryDark),
          ),
        ),
        const SizedBox(height: 12),
        if (onSettingsTap != null) ...[
          GestureDetector(
            onTap: onSettingsTap,
            child: Stack(
              children: [
                GlassContainer(
                  borderRadius: 30,
                  padding: const EdgeInsets.all(14),
                  child: Icon(Icons.tune, color: AppColors.primaryDark),
                ),
                if (hasCustomPrefs)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.warning,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        GestureDetector(
          onTap: onResetTap,
          child: GlassContainer(
            borderRadius: 30,
            padding: const EdgeInsets.all(14),
            child: Icon(Icons.my_location, color: AppColors.primaryDark),
          ),
        ),
      ],
    );
  }
}
