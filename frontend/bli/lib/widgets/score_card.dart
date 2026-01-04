import 'package:bli/models/models.dart';
import 'package:bli/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ScoreCard extends StatefulWidget {
  final LivabilityScore score;

  const ScoreCard({super.key, required this.score});

  @override
  State<ScoreCard> createState() => _ScoreCardState();
}

class _ScoreCardState extends State<ScoreCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final score = widget.score;
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
      clipBehavior: Clip.antiAlias,
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
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: Container(
            constraints: _isExpanded
                ? BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  )
                : null,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Livability Score',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            AnimatedRotation(
                              turns: _isExpanded ? 0.5 : 0,
                              duration: const Duration(milliseconds: 300),
                              child: const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.white,
                                size: 24,
                              ),
                            ),
                          ],
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
                  ),
                  if (_isExpanded)
                    _buildExpandedContent(
                      score,
                      positiveFactors,
                      negativeFactors,
                      positiveTotal,
                      negativeTotal,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent(
    LivabilityScore score,
    List<Factor> positiveFactors,
    List<Factor> negativeFactors,
    double positiveTotal,
    double negativeTotal,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            _ScoreSummaryChip(
              icon: Icons.trending_flat,
              label: score.baseScore.toStringAsFixed(0),
              color: Colors.white.withValues(alpha: 0.15),
              tooltip: 'Base Score',
            ),
            const SizedBox(width: 6),
            _ScoreSummaryChip(
              icon: Icons.add_circle,
              label: '+${positiveTotal.toStringAsFixed(1)}',
              color: Colors.white.withValues(alpha: 0.2),
            ),
            const SizedBox(width: 6),
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
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.3,
          ),
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
                    (factor) => ScoreFactorItem(
                      factor: factor,
                      nearbyFeatures: score.nearbyFeatures,
                    ),
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
                    (factor) => ScoreFactorItem(
                      factor: factor,
                      nearbyFeatures: score.nearbyFeatures,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ScoreSummaryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final String? tooltip;

  const _ScoreSummaryChip({
    required this.icon,
    required this.label,
    required this.color,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final chip = Container(
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

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: chip);
    }
    return chip;
  }
}

class ScoreFactorItem extends StatelessWidget {
  final Factor factor;
  final Map<String, List<FeatureDetail>> nearbyFeatures;

  const ScoreFactorItem({
    super.key,
    required this.factor,
    required this.nearbyFeatures,
  });

  List<FeatureDetail> _getFeaturesForFactor() {
    final factorName = factor.factor.toLowerCase();

    // Map factor names to feature keys
    if (factorName.contains('greenery')) {
      return [
        ...(nearbyFeatures['trees'] ?? []),
        ...(nearbyFeatures['parks'] ?? []),
      ];
    }
    if (factorName.contains('amenities')) {
      return nearbyFeatures['amenities'] ?? [];
    }
    if (factorName.contains('public transport')) {
      return nearbyFeatures['public_transport'] ?? [];
    }
    if (factorName.contains('healthcare')) {
      return nearbyFeatures['healthcare'] ?? [];
    }
    if (factorName.contains('bike infrastructure')) {
      return nearbyFeatures['bike_infrastructure'] ?? [];
    }
    if (factorName.contains('education')) {
      return nearbyFeatures['education'] ?? [];
    }
    if (factorName.contains('sports')) {
      return nearbyFeatures['sports_leisure'] ?? [];
    }
    if (factorName.contains('pedestrian')) {
      return nearbyFeatures['pedestrian_infrastructure'] ?? [];
    }
    if (factorName.contains('cultural')) {
      return nearbyFeatures['cultural_venues'] ?? [];
    }

    // Negative factors
    if (factorName.contains('traffic')) {
      return nearbyFeatures['accidents'] ?? [];
    }
    if (factorName.contains('industrial')) {
      return nearbyFeatures['industrial'] ?? [];
    }
    if (factorName.contains('major road')) {
      return nearbyFeatures['major_roads'] ?? [];
    }
    if (factorName.contains('noise')) {
      return nearbyFeatures['noise_sources'] ?? [];
    }
    if (factorName.contains('railway')) return nearbyFeatures['railways'] ?? [];
    if (factorName.contains('gas')) return nearbyFeatures['gas_stations'] ?? [];
    if (factorName.contains('waste')) {
      return nearbyFeatures['waste_facilities'] ?? [];
    }
    if (factorName.contains('power')) {
      return nearbyFeatures['power_infrastructure'] ?? [];
    }
    if (factorName.contains('parking')) {
      return nearbyFeatures['parking_lots'] ?? [];
    }
    if (factorName.contains('airport')) return nearbyFeatures['airports'] ?? [];
    if (factorName.contains('construction')) {
      return nearbyFeatures['construction_sites'] ?? [];
    }

    return [];
  }

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
      case 'railway':
        return Icons.train;
      case 'gas station':
        return Icons.local_gas_station;
      case 'waste facility':
        return Icons.delete;
      case 'power infrastructure':
        return Icons.electrical_services;
      case 'large parking':
        return Icons.local_parking;
      case 'airport/helipad':
        return Icons.flight;
      case 'construction site':
        return Icons.construction;
      default:
        return factor.impact == 'positive'
            ? Icons.add_circle
            : Icons.remove_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final features = _getFeaturesForFactor();
    final isPositive = factor.impact == 'positive';
    final color = isPositive ? Colors.greenAccent : Colors.orangeAccent;

    // Only sort features with distance
    features.sort((a, b) => a.distance.compareTo(b.distance));
    final displayFeatures = features.take(10).toList(); // Show max 10

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(left: 16, bottom: 8),
        iconColor: AppColors.white,
        collapsedIconColor: AppColors.white.withValues(alpha: 0.5),
        dense: true,
        title: Row(
          children: [
            Icon(_getIconForFactor(factor.factor), color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${factor.factor}: ${factor.description}',
                style: const TextStyle(color: AppColors.white, fontSize: 13),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isPositive
                    ? Colors.green.withValues(alpha: 0.2)
                    : Colors.deepOrange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isPositive
                      ? Colors.green.withValues(alpha: 0.5)
                      : Colors.deepOrange.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Text(
                factor.value >= 0
                    ? '+${factor.value.toStringAsFixed(1)}'
                    : factor.value.toStringAsFixed(1),
                style: TextStyle(
                  color: isPositive ? Colors.greenAccent : Colors.orangeAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        children: displayFeatures.isEmpty
            ? [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    "No detailed features available.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ]
            : displayFeatures.map((feature) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Icon(
                        Icons.place,
                        size: 12,
                        color: AppColors.white.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "${feature.name ?? feature.subtype ?? feature.type} (${feature.distance.toStringAsFixed(0)}m)",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
      ),
    );
  }
}

Color getScoreColor(double score) {
  if (score >= 75) return Colors.teal[700]!;
  if (score >= 50) return Colors.orange[800]!;
  return Colors.red[700]!;
}
