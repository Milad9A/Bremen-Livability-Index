import 'package:bli/core/theme/app_theme.dart';
import 'package:bli/core/widgets/glass_container.dart';
import 'package:flutter/material.dart';

class MapControlButtons extends StatelessWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onResetTap;

  const MapControlButtons({
    super.key,
    required this.onProfileTap,
    required this.onResetTap,
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
