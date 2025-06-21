import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String day;
  final String temperature;
  final String description;

  const WeatherCard({
    super.key,
    required this.day,
    required this.temperature,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(day),
        subtitle: Text(description),
        trailing: Text(temperature, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
