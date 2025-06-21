import 'package:flutter/material.dart';
import 'package:weatherapp/core/models/forecast_outlook.dart';
import 'package:weatherapp/l10n/app_localizations.dart';

class FarmingPredictionCard extends StatefulWidget {
  final OutlookAnalysis? analysis;

  const FarmingPredictionCard({super.key, required this.analysis});

  @override
  State<FarmingPredictionCard> createState() => _FarmingPredictionCardState();
}

class _FarmingPredictionCardState extends State<FarmingPredictionCard> {
  String mainRecommendation = '';
  Map<String, String> recommendations = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateRecommendations();
  }

  void _updateRecommendations() {
    final l10n = AppLocalizations.of(context)!;
    recommendations = {
      'rainy_season': l10n.rainySeasonAheadBody,
      'dry_season': l10n.drySeasonAheadBody,
      'summer_heat': l10n.summerHeatAheadBody,
      'cold_season': l10n.coldSeasonAheadBody,
    };
    final recommendationKey = widget.analysis?.recommendation;
    mainRecommendation =
        recommendations[recommendationKey] ?? l10n.defaultRecommendation;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final titleStyle = Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold);
    final bodyStyle = Theme.of(context).textTheme.bodyMedium;

    if (widget.analysis == null) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.red.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.farmingAnalysisUnavailable,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.agriculture,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(l10n.farmingPredictionCardTitle, style: titleStyle),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            context,
            icon: Icons.thermostat,
            label: l10n.avgTemp16Days,
            value:
                "${widget.analysis!.averageTemperature.toStringAsFixed(1)}°C",
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            context,
            icon: Icons.water_drop_outlined,
            label: l10n.avgRainfall16Days,
            value:
                "${widget.analysis!.averagePrecipitation.toStringAsFixed(1)}%",
          ),
          const Divider(height: 24, thickness: 0.5),
          Text(
            l10n.primaryRecommendation,
            style: titleStyle?.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(mainRecommendation, style: bodyStyle),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
