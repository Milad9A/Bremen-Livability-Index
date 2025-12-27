import 'package:flutter/material.dart';
import '../services/api_service.dart';

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
              getScoreColor(score.score).withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
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
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${score.score.toStringAsFixed(1)}/100',
                    style: const TextStyle(
                      color: Colors.white,
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
                  color: Colors.white,
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
                  color: Colors.white,
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
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${factor.factor}: ${factor.description}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          Text(
            factor.value >= 0
                ? '+${factor.value.toStringAsFixed(1)}'
                : factor.value.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
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
  if (score >= 70) return Colors.green;
  if (score >= 50) return Colors.orange;
  return Colors.red;
}
