import 'package:flutter/material.dart';
import '../../../core/models/daily_weather.dart';
import '../../../core/utils/weather_code_mapper.dart';
import 'package:intl/intl.dart';
import 'daily_weather_details.dart';

class DailyForecast extends StatelessWidget {
  final List<DailyWeather> forecasts;
  const DailyForecast({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: forecasts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final day = forecasts[i];
          final dayName = DateFormat('E').format(day.date); // Sun, Mon, etc.
          return GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => DailyWeatherDetails(day: day),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                isScrollControlled: true,
              );
            },
            child: Container(
              width: 80,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(dayName, style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 2),
                  Text(
                    WeatherCodeMapper.icon(day.weatherCode),
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    WeatherCodeMapper.description(day.weatherCode),
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${day.tempMax.toStringAsFixed(0)}° / ${day.tempMin.toStringAsFixed(0)}°',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
