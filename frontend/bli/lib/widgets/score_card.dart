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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    getScoreColor(score.score),
                    getScoreColor(score.score).withValues(alpha: 0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Livability Score',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${score.score.toStringAsFixed(1)}/100',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _isExpanded
                ? Container(
                    child: _buildExpandedContent(
                      score,
                      positiveFactors,
                      negativeFactors,
                      positiveTotal,
                      negativeTotal,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
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
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _ScoreSummaryChip(
                    icon: Icons.trending_flat,
                    label: score.baseScore.toStringAsFixed(0),
                    backgroundColor: Colors.grey.withValues(alpha: 0.1),
                    textColor: Colors.black87,
                    iconColor: Colors.grey,
                    tooltip: 'Base Score',
                  ),
                  const SizedBox(width: 8),
                  _ScoreSummaryChip(
                    icon: Icons.add_circle,
                    label: '+${positiveTotal.toStringAsFixed(1)}',
                    backgroundColor: Colors.green.withValues(alpha: 0.1),
                    textColor: Colors.green[700]!,
                    iconColor: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  _ScoreSummaryChip(
                    icon: Icons.remove_circle,
                    label: '-${negativeTotal.toStringAsFixed(1)}',
                    backgroundColor: Colors.red.withValues(alpha: 0.1),
                    textColor: Colors.red[700]!,
                    iconColor: Colors.red,
                  ),
                  const Spacer(),
                  Text(
                    '${score.factors.length} factors',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                score.summary,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.4,
          ),
          child: Scrollbar(
            thumbVisibility: true,
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (positiveFactors.isNotEmpty) ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.thumb_up,
                          color: Colors.green,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Positive Factors',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...positiveFactors.map(
                      (factor) => ScoreFactorItem(
                        factor: factor,
                        nearbyFeatures: score.nearbyFeatures,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (negativeFactors.isNotEmpty) ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.thumb_down,
                          color: Colors.red,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Negative Factors',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
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
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final String? tooltip;

  const _ScoreSummaryChip({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
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

    Color factorColor = FeatureStyles.getFactorColor(factor.factor);
    if (factorColor == AppColors.greyLight) {
      factorColor = isPositive ? Colors.green : Colors.red;
    }

    IconData factorIcon = FeatureStyles.getFactorIcon(factor.factor);
    if (factorIcon == Icons.help_outline &&
        factor.factor == MetricCategory.unknown) {
      factorIcon = isPositive ? Icons.add_circle : Icons.remove_circle;
    }

    // Sort by distance
    features.sort((a, b) => a.distance.compareTo(b.distance));
    final displayFeatures = features.take(10).toList();

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(left: 0, bottom: 8),
        iconColor: Colors.grey[600],
        collapsedIconColor: Colors.grey[400],
        dense: true,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: factorColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(factorIcon, color: factorColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                factor.description,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isPositive
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                factor.value >= 0
                    ? '+${factor.value.toStringAsFixed(1)}'
                    : factor.value.toStringAsFixed(1),
                style: TextStyle(
                  color: isPositive ? Colors.green[700] : Colors.red[700],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        children: displayFeatures.isEmpty
            ? [
                Padding(
                  padding: const EdgeInsets.only(left: 42, top: 4, bottom: 4),
                  child: Text(
                    "No detailed features available.",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ]
            : displayFeatures.map((feature) {
                return Padding(
                  padding: const EdgeInsets.only(left: 42, top: 2, bottom: 2),
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
                          feature.name ?? feature.subtype ?? feature.type.name,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        "${feature.distance.toStringAsFixed(0)}m",
                        style: TextStyle(color: Colors.grey[500], fontSize: 11),
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
