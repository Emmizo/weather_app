class Weather {
  final double temperature;
  final double windspeed;
  final double winddirection;
  final int weathercode;
  final DateTime time;

  Weather({
    required this.temperature,
    required this.windspeed,
    required this.winddirection,
    required this.weathercode,
    required this.time,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final current = json['current_weather'];
    return Weather(
      temperature: current['temperature']?.toDouble() ?? 0.0,
      windspeed: current['windspeed']?.toDouble() ?? 0.0,
      winddirection: current['winddirection']?.toDouble() ?? 0.0,
      weathercode: current['weathercode'] ?? 0,
      time: DateTime.parse(current['time']),
    );
  }
}
