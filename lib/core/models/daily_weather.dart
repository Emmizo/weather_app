class DailyWeather {
  final DateTime date;
  final double tempMax;
  final double tempMin;
  final int weatherCode;
  final DateTime? sunrise;
  final DateTime? sunset;
  final double? moonPhase;
  final double? windSpeed;

  DailyWeather({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.weatherCode,
    this.sunrise,
    this.sunset,
    this.moonPhase,
    this.windSpeed,
  });

  static List<DailyWeather> fromDailyJson(Map<String, dynamic> json) {
    final times = json['time'] as List<dynamic>;
    final maxTemps = json['temperature_2m_max'] as List<dynamic>;
    final minTemps = json['temperature_2m_min'] as List<dynamic>;
    final codes = json['weathercode'] as List<dynamic>;
    final sunrises = json['sunrise'] as List<dynamic>?;
    final sunsets = json['sunset'] as List<dynamic>?;
    final moonPhases = json['moon_phase'] as List<dynamic>?;
    return List.generate(
      times.length,
      (i) => DailyWeather(
        date: DateTime.parse(times[i]),
        tempMax: (maxTemps[i] as num).toDouble(),
        tempMin: (minTemps[i] as num).toDouble(),
        weatherCode: codes[i] as int,
        sunrise: sunrises != null ? DateTime.tryParse(sunrises[i]) : null,
        sunset: sunsets != null ? DateTime.tryParse(sunsets[i]) : null,
        moonPhase: moonPhases != null
            ? (moonPhases[i] as num).toDouble()
            : null,
      ),
    );
  }

  static List<DailyWeather> fromDailyJsonWithWind(
    Map<String, dynamic> dailyJson,
    List<double?> hourlyWindSpeeds,
  ) {
    final dailyWeather = fromDailyJson(dailyJson);

    // Calculate average wind speed for each day from hourly data
    for (int i = 0; i < dailyWeather.length; i++) {
      final dayStart = i * 24;
      final dayWindSpeeds = hourlyWindSpeeds
          .skip(dayStart)
          .take(24)
          .where((speed) => speed != null)
          .map((speed) => speed!)
          .toList();

      final averageWindSpeed = dayWindSpeeds.isNotEmpty
          ? dayWindSpeeds.reduce((a, b) => a + b) / dayWindSpeeds.length
          : null;

      dailyWeather[i] = DailyWeather(
        date: dailyWeather[i].date,
        tempMax: dailyWeather[i].tempMax,
        tempMin: dailyWeather[i].tempMin,
        weatherCode: dailyWeather[i].weatherCode,
        sunrise: dailyWeather[i].sunrise,
        sunset: dailyWeather[i].sunset,
        moonPhase: dailyWeather[i].moonPhase,
        windSpeed: averageWindSpeed,
      );
    }

    return dailyWeather;
  }
}
