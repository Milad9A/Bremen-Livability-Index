import 'package:bli/models/enums.dart';
import 'package:bli/models/models.dart';
import 'package:bli/theme/app_theme.dart';
import 'package:bli/utils/feature_styles.dart';
import 'package:flutter/material.dart';

class ScoreCard extends StatefulWidget {
  final LivabilityScore score;

  const ScoreCard({super.key, required this.score});

  @override
  State<ScoreCard> createState() => _ScoreCardState();
}

class _ScoreCardState extends State<ScoreCard> {
  bool _isExpanded = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
          child: Scrollbar(
            thumbVisibility: true,
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.only(right: 16.0),
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
    switch (factor.factor) {
      case MetricCategory.greenery:
        return [
          ...(nearbyFeatures['trees'] ?? []),
          ...(nearbyFeatures['parks'] ?? []),
        ];
      case MetricCategory.amenities:
        return nearbyFeatures['amenities'] ?? [];
      case MetricCategory.publicTransport:
        return nearbyFeatures['public_transport'] ?? [];
      case MetricCategory.healthcare:
        return nearbyFeatures['healthcare'] ?? [];
      case MetricCategory.bikeInfrastructure:
        return nearbyFeatures['bike_infrastructure'] ?? [];
      case MetricCategory.education:
        return nearbyFeatures['education'] ?? [];
      case MetricCategory.sportsLeisure:
        return nearbyFeatures['sports_leisure'] ?? [];
      case MetricCategory.pedestrianInfrastructure:
        return nearbyFeatures['pedestrian_infrastructure'] ?? [];
      case MetricCategory.culturalVenues:
        return nearbyFeatures['cultural_venues'] ?? [];
      case MetricCategory.trafficSafety:
        return nearbyFeatures['accidents'] ?? [];
      case MetricCategory.industrialArea:
        return nearbyFeatures['industrial'] ?? [];
      case MetricCategory.majorRoad:
        return nearbyFeatures['major_roads'] ?? [];
      case MetricCategory.noiseSources:
        return nearbyFeatures['noise_sources'] ?? [];
      case MetricCategory.railway:
        return nearbyFeatures['railways'] ?? [];
      case MetricCategory.gasStation:
        return nearbyFeatures['gas_stations'] ?? [];
      case MetricCategory.wasteFacility:
        return nearbyFeatures['waste_facilities'] ?? [];
      case MetricCategory.powerInfrastructure:
        return nearbyFeatures['power_infrastructure'] ?? [];
      case MetricCategory.largeParking:
        return nearbyFeatures['parking_lots'] ?? [];
      case MetricCategory.airport:
        return nearbyFeatures['airports'] ?? [];
      case MetricCategory.constructionSite:
        return nearbyFeatures['construction_sites'] ?? [];
      case MetricCategory.unknown:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final features = _getFeaturesForFactor();
    final isPositive = factor.impact == 'positive';

    // Get color from unified styles
    Color factorColor = FeatureStyles.getFactorColor(factor.factor);
    if (factorColor == AppColors.greyLight) {
      factorColor = isPositive ? Colors.green : Colors.red;
    }

    // Get icon from unified styles
    IconData factorIcon = FeatureStyles.getFactorIcon(factor.factor);
    if (factorIcon == Icons.help_outline &&
        factor.factor == MetricCategory.unknown) {
      factorIcon = isPositive ? Icons.add_circle : Icons.remove_circle;
    }

    // Only sort features with distance
    features.sort((a, b) => a.distance.compareTo(b.distance));
    final displayFeatures = features.take(10).toList(); // Show max 10

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(left: 16, bottom: 8),
        iconColor: factorColor,
        collapsedIconColor: factorColor.withValues(alpha: 0.7),
        dense: true,
        title: Row(
          children: [
            Icon(factorIcon, color: factorColor, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                factor.description,
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
                        FeatureStyles.getFeatureIcon(
                          feature.type,
                          subtype: feature.subtype,
                        ),
                        size: 14,
                        color: factorColor.withValues(alpha: 0.8),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "${feature.name ?? feature.subtype ?? feature.type.name} (${feature.distance.toStringAsFixed(0)}m)",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
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
