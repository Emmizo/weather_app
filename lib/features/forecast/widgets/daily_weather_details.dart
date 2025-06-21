import 'package:flutter/material.dart';
import '../../../core/models/daily_weather.dart';
import '../../../core/utils/weather_code_mapper.dart';
import '../../../core/utils/date_utils.dart';

class DailyWeatherDetails extends StatelessWidget {
  final DailyWeather day;
  const DailyWeatherDetails({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateUtilsX.formatDate(day.date),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              WeatherCodeMapper.icon(day.weatherCode),
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 8),
            Text(
              WeatherCodeMapper.description(day.weatherCode),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'High: ${day.tempMax.toStringAsFixed(1)}°  |  Low: ${day.tempMin.toStringAsFixed(1)}°',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            if (day.sunrise != null)
              Text(
                'Sunrise: ${TimeOfDay.fromDateTime(day.sunrise!).format(context)}',
              ),
            if (day.sunset != null)
              Text(
                'Sunset: ${TimeOfDay.fromDateTime(day.sunset!).format(context)}',
              ),
            const SizedBox(height: 16),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
