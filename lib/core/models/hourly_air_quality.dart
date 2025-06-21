class HourlyAirQuality {
  final DateTime time;
  final double? pm10;
  final double? pm2_5;
  final int? aqi;

  HourlyAirQuality({required this.time, this.pm10, this.pm2_5, this.aqi});

  static List<HourlyAirQuality> fromJson(Map<String, dynamic> json) {
    final times = json['time'] as List<dynamic>;
    final pm10s = json['pm10'] as List<dynamic>?;
    final pm2_5s = json['pm2_5'] as List<dynamic>?;
    final aqis = json['european_aqi'] as List<dynamic>?;
    return List.generate(
      times.length,
      (i) => HourlyAirQuality(
        time: DateTime.parse(times[i]),
        pm10: pm10s != null ? (pm10s[i] as num?)?.toDouble() : null,
        pm2_5: pm2_5s != null ? (pm2_5s[i] as num?)?.toDouble() : null,
        aqi: aqis != null ? (aqis[i] as num?)?.toInt() : null,
      ),
    );
  }
}
