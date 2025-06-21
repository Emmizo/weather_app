import 'package:flutter/material.dart';
import '../../../core/models/hourly_air_quality.dart';

class AirQualityCard extends StatelessWidget {
  final List<HourlyAirQuality> airQuality;
  const AirQualityCard({super.key, required this.airQuality});

  @override
  Widget build(BuildContext context) {
    if (airQuality.isEmpty) return const SizedBox.shrink();
    final currentAirQuality = airQuality.first;
    return Card(
      color: Theme.of(context).colorScheme.surface.withOpacity(0.85),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (currentAirQuality.aqi != null)
              _buildAirQualityItem(
                context,
                'AQI',
                Icons.air,
                Colors.green,
                '${currentAirQuality.aqi}',
              ),
            if (currentAirQuality.pm2_5 != null)
              _buildAirQualityItem(
                context,
                'PM2.5',
                Icons.blur_on,
                Colors.orange,
                '${currentAirQuality.pm2_5!.toStringAsFixed(1)}',
              ),
            if (currentAirQuality.pm10 != null)
              _buildAirQualityItem(
                context,
                'PM10',
                Icons.blur_on,
                Colors.blue,
                '${currentAirQuality.pm10!.toStringAsFixed(1)}',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAirQualityItem(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    String value,
  ) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        Text(value),
      ],
    );
  }
}
