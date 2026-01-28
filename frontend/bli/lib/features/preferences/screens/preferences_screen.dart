import 'package:bli/features/preferences/bloc/preferences_bloc.dart';
import 'package:bli/features/preferences/bloc/preferences_event.dart';
import 'package:bli/features/preferences/bloc/preferences_state.dart';
import 'package:bli/features/preferences/models/user_preferences.dart';
import 'package:bli/features/preferences/widgets/factor_preference_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bli/core/theme/app_theme.dart';

/// Screen for configuring scoring factor preferences.
class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  // Factor display data: (key, label, isNegative)
  static const List<(String, String, bool)> _positiveFactors = [
    ('greenery', 'Parks & Trees', false),
    ('amenities', 'Shops & Services', false),
    ('public_transport', 'Public Transport', false),
    ('healthcare', 'Healthcare', false),
    ('bike_infrastructure', 'Bike Infrastructure', false),
    ('education', 'Schools & Education', false),
    ('sports_leisure', 'Sports & Leisure', false),
    ('pedestrian_infrastructure', 'Pedestrian Paths', false),
    ('cultural', 'Culture & Arts', false),
  ];

  static const List<(String, String, bool)> _negativeFactors = [
    ('accidents', 'Traffic Safety', true),
    ('industrial', 'Industrial Areas', true),
    ('major_roads', 'Major Roads', true),
    ('noise', 'Noise Sources', true),
    ('railway', 'Railways', true),
    ('gas_station', 'Gas Stations', true),
    ('waste', 'Waste Facilities', true),
    ('power', 'Power Lines', true),
    ('parking', 'Large Parking Lots', true),
    ('airport', 'Airports & Helipads', true),
    ('construction', 'Construction Sites', true),
  ];

  ImportanceLevel _getLevelForFactor(UserPreferences prefs, String key) {
    switch (key) {
      case 'greenery':
        return prefs.greenery;
      case 'amenities':
        return prefs.amenities;
      case 'public_transport':
        return prefs.publicTransport;
      case 'healthcare':
        return prefs.healthcare;
      case 'bike_infrastructure':
        return prefs.bikeInfrastructure;
      case 'education':
        return prefs.education;
      case 'sports_leisure':
        return prefs.sportsLeisure;
      case 'pedestrian_infrastructure':
        return prefs.pedestrianInfrastructure;
      case 'cultural':
        return prefs.cultural;
      case 'accidents':
        return prefs.accidents;
      case 'industrial':
        return prefs.industrial;
      case 'major_roads':
        return prefs.majorRoads;
      case 'noise':
        return prefs.noise;
      case 'railway':
        return prefs.railway;
      case 'gas_station':
        return prefs.gasStation;
      case 'waste':
        return prefs.waste;
      case 'power':
        return prefs.power;
      case 'parking':
        return prefs.parking;
      case 'airport':
        return prefs.airport;
      case 'construction':
        return prefs.construction;
      default:
        return ImportanceLevel.medium;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Score Preferences'),
        actions: [
          BlocBuilder<PreferencesBloc, PreferencesState>(
            builder: (context, state) {
              if (!state.isCustomized) return const SizedBox.shrink();
              return TextButton(
                onPressed: () {
                  context.read<PreferencesBloc>().add(const ResetToDefaults());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Preferences reset to defaults'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text('Reset'),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<PreferencesBloc, PreferencesState>(
        builder: (context, state) {
          final prefs = state.preferences;

          return ListView(
            children: [
              // Info banner
              if (state.isCustomized)
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.tune, color: AppColors.primaryDark),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Custom preferences active. Scores will be calculated using your settings.',
                          style: TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Cloud sync indicator
              if (state.isSyncedToCloud)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.cloud_done,
                        size: 16,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Synced to your account',
                        style: TextStyle(
                          color: AppColors.success,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 8),

              // Positive factors section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Positive Factors',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.successDark,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'These features increase your livability score',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ..._positiveFactors.map((factor) {
                final (key, label, isNegative) = factor;
                return FactorPreferenceRow(
                  label: label,
                  factorKey: key,
                  currentLevel: _getLevelForFactor(prefs, key),
                  isNegative: isNegative,
                  onChanged: (level) {
                    context.read<PreferencesBloc>().add(
                      UpdateFactor(factorKey: key, level: level),
                    );
                  },
                );
              }),

              const Divider(height: 32),

              // Negative factors section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(
                  'Penalty Factors',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.scoreMedium,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'These features decrease your livability score',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ..._negativeFactors.map((factor) {
                final (key, label, isNegative) = factor;
                return FactorPreferenceRow(
                  label: label,
                  factorKey: key,
                  currentLevel: _getLevelForFactor(prefs, key),
                  isNegative: isNegative,
                  onChanged: (level) {
                    context.read<PreferencesBloc>().add(
                      UpdateFactor(factorKey: key, level: level),
                    );
                  },
                );
              }),

              const SizedBox(height: 24),

              // Legend
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Importance Levels',
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    _buildLegendItem('Off', 'Factor is completely ignored'),
                    _buildLegendItem('Low', 'Factor has reduced impact (0.5x)'),
                    _buildLegendItem('Med', 'Default importance (1.0x)'),
                    _buildLegendItem(
                      'High',
                      'Factor has increased impact (1.5x)',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLegendItem(String level, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              level,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(description, style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
