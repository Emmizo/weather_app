class HourlyWeather {
  final DateTime time;
  final double temperature;
  final double precipitation;
  final int weatherCode;
  final double? pm10;
  final double? pm2_5;
  final int? aqi;
  final double? windSpeed;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.precipitation,
    required this.weatherCode,
    this.pm10,
    this.pm2_5,
    this.aqi,
    this.windSpeed,
  });

  static List<HourlyWeather> fromHourlyJson(Map<String, dynamic> json) {
    final times = json['time'] as List<dynamic>;
    final temps = json['temperature_2m'] as List<dynamic>;
    final precs = json['precipitation_probability'] as List<dynamic>;
    final codes = json['weathercode'] as List<dynamic>;
    final pm10s = json['pm10'] as List<dynamic>?;
    final pm2_5s = json['pm2_5'] as List<dynamic>?;
    final aqis = json['european_aqi'] as List<dynamic>?;
    final windSpeeds = json['windspeed_10m'] as List<dynamic>?;
    return List.generate(
      times.length,
      (i) => HourlyWeather(
        time: DateTime.parse(times[i]),
        temperature: (temps[i] as num).toDouble(),
        precipitation: (precs[i] as num).toDouble(),
        weatherCode: codes[i] as int,
        pm10: pm10s != null ? (pm10s[i] as num?)?.toDouble() : null,
        pm2_5: pm2_5s != null ? (pm2_5s[i] as num?)?.toDouble() : null,
        aqi: aqis != null ? (aqis[i] as num?)?.toInt() : null,
        windSpeed: windSpeeds != null
            ? (windSpeeds[i] as num?)?.toDouble()
            : null,
      ),
    );
  }
}
