import 'package:bli/core/theme/app_theme.dart';
import 'package:bli/features/preferences/models/user_preferences.dart';
import 'package:flutter/material.dart';

/// A single row for configuring a factor's importance level.
class FactorPreferenceRow extends StatelessWidget {
  final String label;
  final String factorKey;
  final ImportanceLevel currentLevel;
  final bool isNegative;
  final ValueChanged<ImportanceLevel> onChanged;

  const FactorPreferenceRow({
    super.key,
    required this.label,
    required this.factorKey,
    required this.currentLevel,
    required this.onChanged,
    this.isNegative = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use app theme colors
    final positiveColor = AppColors.successDark;
    final positiveBg = AppColors.successLight;
    final negativeColor = AppColors.scoreMedium; // Orange/Warning color
    final negativeBg = AppColors.warning.withValues(alpha: 0.1);

    final activeColor = isNegative ? negativeColor : positiveColor;
    final activeBg = isNegative ? negativeBg : positiveBg;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            isNegative ? Icons.remove_circle_outline : Icons.add_circle_outline,
            size: 20,
            color: activeColor,
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          SegmentedButton<ImportanceLevel>(
            segments: ImportanceLevel.values.map((level) {
              return ButtonSegment<ImportanceLevel>(
                value: level,
                label: Text(level.label, style: const TextStyle(fontSize: 11)),
              );
            }).toList(),
            selected: {currentLevel},
            onSelectionChanged: (selection) {
              if (selection.isNotEmpty) {
                onChanged(selection.first);
              }
            },
            showSelectedIcon: false,
            style: ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                states,
              ) {
                if (states.contains(WidgetState.selected)) {
                  return activeBg;
                }
                return null;
              }),
              foregroundColor: WidgetStateProperty.resolveWith<Color?>((
                states,
              ) {
                if (states.contains(WidgetState.selected)) {
                  return activeColor;
                }
                return null;
              }),
            ),
          ),
        ],
      ),
    );
  }
}
