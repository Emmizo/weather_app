import 'package:flutter/material.dart';
import '../../../core/api/openai_service.dart';
import '../../../core/models/weather.dart';
import '../../../core/models/hourly_weather.dart';
import '../../../core/models/daily_weather.dart';
import '../../../core/models/hourly_air_quality.dart';
import '../../../l10n/app_localizations.dart';

class AIWeatherInsightsCard extends StatefulWidget {
  final Weather currentWeather;
  final List<HourlyWeather> hourlyForecasts;
  final List<DailyWeather> dailyForecasts;
  final HourlyAirQuality? airQuality;
  final String locationName;

  const AIWeatherInsightsCard({
    super.key,
    required this.currentWeather,
    required this.hourlyForecasts,
    required this.dailyForecasts,
    required this.airQuality,
    required this.locationName,
  });

  @override
  State<AIWeatherInsightsCard> createState() => _AIWeatherInsightsCardState();
}

class _AIWeatherInsightsCardState extends State<AIWeatherInsightsCard> {
  final OpenAIService _openAIService = OpenAIService();
  String _insights = '';
  String _activities = '';
  String _clothing = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Always load fresh AI insights when the screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAIInsights();
    });
  }

  Future<void> _loadAIInsights() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get current locale from context
      final locale = Localizations.localeOf(context);
      final languageCode = locale.languageCode;

      final insights = await _openAIService.generateWeatherInsights(
        currentWeather: widget.currentWeather,
        hourlyForecasts: widget.hourlyForecasts,
        dailyForecasts: widget.dailyForecasts,
        airQuality: widget.airQuality,
        locationName: widget.locationName,
        languageCode: languageCode,
      );

      final activities = await _openAIService.generateActivityRecommendations(
        currentWeather: widget.currentWeather,
        hourlyForecasts: widget.hourlyForecasts,
        airQuality: widget.airQuality,
        languageCode: languageCode,
      );

      final clothing = await _openAIService.generateClothingRecommendations(
        currentWeather: widget.currentWeather,
        hourlyForecasts: widget.hourlyForecasts,
        languageCode: languageCode,
      );

      if (mounted) {
        setState(() {
          _insights = insights;
          _activities = activities;
          _clothing = clothing;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.1),
              theme.colorScheme.secondary.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.psychology,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.aiWeatherInsights,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  if (_isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                Center(
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 8),
                      Text(l10n.generatingAIInsights),
                    ],
                  ),
                )
              else if (_insights.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInsightSection(
                      context,
                      l10n.weatherSummary,
                      _insights,
                      Icons.info_outline,
                    ),
                    const SizedBox(height: 16),
                    _buildInsightSection(
                      context,
                      l10n.activitySuggestions,
                      _activities,
                      Icons.sports_soccer,
                    ),
                    const SizedBox(height: 16),
                    _buildInsightSection(
                      context,
                      l10n.clothingRecommendations,
                      _clothing,
                      Icons.checkroom,
                    ),
                  ],
                )
              else
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.aiInsightsError,
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadAIInsights,
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsightSection(
    BuildContext context,
    String title,
    String content,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(content, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
