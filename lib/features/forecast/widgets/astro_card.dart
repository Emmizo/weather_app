import 'package:flutter/material.dart';
import 'package:weatherapp/l10n/app_localizations.dart';
import '../../../core/models/daily_weather.dart';

class AstroCard extends StatelessWidget {
  final DailyWeather day;
  const AstroCard({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      color: Theme.of(context).colorScheme.surface.withOpacity(0.85),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (day.sunrise != null)
              _buildAstroItem(
                context,
                l10n.sunrise,
                Icons.wb_twighlight,
                Colors.orange,
                TimeOfDay.fromDateTime(day.sunrise!).format(context),
              ),
            if (day.sunset != null)
              _buildAstroItem(
                context,
                l10n.sunset,
                Icons.nights_stay,
                Colors.deepOrange,
                TimeOfDay.fromDateTime(day.sunset!).format(context),
              ),
            if (day.moonPhase != null)
              _buildAstroItem(
                context,
                l10n.moonPhase,
                Icons.brightness_2,
                Colors.blueGrey,
                '${(day.moonPhase! * 100).toStringAsFixed(0)}%',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAstroItem(
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
