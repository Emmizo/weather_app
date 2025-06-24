import 'package:flutter/material.dart';
import '../../../core/models/weather.dart';
import '../../../core/models/hourly_weather.dart';
import '../../../core/models/daily_weather.dart';
import '../../../core/models/hourly_air_quality.dart';
import '../../../l10n/app_localizations.dart';
import 'ai_weather_insights_card.dart';

class AIWeatherInsightsScreen extends StatelessWidget {
  final Weather currentWeather;
  final List<HourlyWeather> hourlyForecasts;
  final List<DailyWeather> dailyForecasts;
  final HourlyAirQuality? airQuality;
  final String locationName;

  const AIWeatherInsightsScreen({
    super.key,
    required this.currentWeather,
    required this.hourlyForecasts,
    required this.dailyForecasts,
    required this.airQuality,
    required this.locationName,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.aiWeatherInsights)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AIWeatherInsightsCard(
            currentWeather: currentWeather,
            hourlyForecasts: hourlyForecasts,
            dailyForecasts: dailyForecasts,
            airQuality: airQuality,
            locationName: locationName,
          ),
        ),
      ),
    );
  }
}
