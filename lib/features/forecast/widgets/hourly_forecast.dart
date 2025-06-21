import 'package:flutter/material.dart';
import '../../../core/models/hourly_weather.dart';
import '../../../core/utils/weather_code_mapper.dart';

class HourlyForecast extends StatelessWidget {
  final List<HourlyWeather> forecasts;
  const HourlyForecast({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: forecasts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final hour = forecasts[i];
          final time = TimeOfDay.fromDateTime(hour.time).format(context);
          return Container(
            width: 65,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(time, style: Theme.of(context).textTheme.bodySmall),
                Text(
                  WeatherCodeMapper.icon(hour.weatherCode),
                  style: const TextStyle(fontSize: 22),
                ),
                Text(
                  '${hour.temperature.toStringAsFixed(0)}°',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.water_drop_outlined,
                      size: 12,
                      color: Colors.blue.withOpacity(0.7),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${hour.precipitation.toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
