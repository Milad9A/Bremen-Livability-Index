import 'package:bli/services/api_service.dart';
import 'package:bli/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ScoreCard extends StatelessWidget {
  final LivabilityScore score;

  const ScoreCard({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
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
              const SizedBox(height: 16),
              Text(
                score.summary,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white70, thickness: 1),
              const SizedBox(height: 12),
              const Text(
                'Factors:',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...score.factors.map((factor) => ScoreFactorItem(factor: factor)),
            ],
          ),
        ),
      ),
    );
  }
}

class ScoreFactorItem extends StatelessWidget {
  final Factor factor;

  const ScoreFactorItem({super.key, required this.factor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            factor.impact == 'positive'
                ? Icons.add_circle
                : Icons.remove_circle,
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
          Text(
            factor.value >= 0
                ? '+${factor.value.toStringAsFixed(1)}'
                : factor.value.toStringAsFixed(1),
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

Color getScoreColor(double score) {
  if (score >= 75) return Colors.teal[700]!;
  if (score >= 50) return Colors.orange[800]!;
  return Colors.red[700]!;
}
