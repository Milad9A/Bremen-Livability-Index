import 'package:bli/services/api_service.dart';
import 'package:bli/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ScoreCard extends StatelessWidget {
  final LivabilityScore score;

  const ScoreCard({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final positiveFactors = score.factors
        .where((f) => f.impact == 'positive')
        .toList();
    final negativeFactors = score.factors
        .where((f) => f.impact == 'negative')
        .toList();

    final positiveTotal = positiveFactors.fold<double>(
      0,
      (sum, f) => sum + f.value,
    );
    final negativeTotal = negativeFactors.fold<double>(
      0,
      (sum, f) => sum + f.value.abs(),
    );

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.55,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              getScoreColor(score.score),
              getScoreColor(score.score).withValues(alpha: 0.85),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: getScoreColor(score.score).withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Livability Score',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${score.score.toStringAsFixed(1)}/100',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _ScoreSummaryChip(
                    icon: Icons.add_circle,
                    label: '+${positiveTotal.toStringAsFixed(1)}',
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  const SizedBox(width: 8),
                  _ScoreSummaryChip(
                    icon: Icons.remove_circle,
                    label: '-${negativeTotal.toStringAsFixed(1)}',
                    color: Colors.black.withValues(alpha: 0.2),
                  ),
                  const Spacer(),
                  Text(
                    '${score.factors.length} factors',
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                score.summary,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              const Divider(color: Colors.white70, thickness: 1),
              const SizedBox(height: 8),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (positiveFactors.isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(
                              Icons.thumb_up,
                              color: AppColors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Positive Factors (${positiveFactors.length})',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ...positiveFactors.map(
                          (factor) => ScoreFactorItem(factor: factor),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (negativeFactors.isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(
                              Icons.thumb_down,
                              color: AppColors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Negative Factors (${negativeFactors.length})',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ...negativeFactors.map(
                          (factor) => ScoreFactorItem(factor: factor),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreSummaryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ScoreSummaryChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class ScoreFactorItem extends StatelessWidget {
  final Factor factor;

  const ScoreFactorItem({super.key, required this.factor});

  IconData _getIconForFactor(String factorName) {
    switch (factorName.toLowerCase()) {
      case 'greenery':
        return Icons.nature;
      case 'amenities':
        return Icons.store;
      case 'public transport':
        return Icons.directions_bus;
      case 'healthcare':
        return Icons.local_hospital;
      case 'bike infrastructure':
        return Icons.directions_bike;
      case 'education':
        return Icons.school;
      case 'sports & leisure':
        return Icons.sports_soccer;
      case 'pedestrian infrastructure':
        return Icons.accessibility_new;
      case 'cultural venues':
        return Icons.palette;
      case 'traffic safety':
        return Icons.warning;
      case 'industrial area':
        return Icons.factory;
      case 'major road':
        return Icons.add_road;
      case 'noise sources':
        return Icons.volume_up;
      default:
        return factor.impact == 'positive'
            ? Icons.add_circle
            : Icons.remove_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            _getIconForFactor(factor.factor),
            color: AppColors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${factor.factor}: ${factor.description}',
              style: const TextStyle(color: AppColors.white, fontSize: 12),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: factor.impact == 'positive'
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              factor.value >= 0
                  ? '+${factor.value.toStringAsFixed(1)}'
                  : factor.value.toStringAsFixed(1),
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color getScoreColor(double score) {
  if (score >= 75) return Colors.teal[700]!;
  if (score >= 50) return Colors.orange[800]!;
  return Colors.red[700]!;
}
