class OutlookWeather {
  final DateTime date;
  final double tempMax;
  final double tempMin;
  final double precipitationProbability;
  final int weatherCode;

  OutlookWeather({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.precipitationProbability,
    required this.weatherCode,
  });

  static List<OutlookWeather> fromJson(Map<String, dynamic> json) {
    final times = json['time'] as List<dynamic>;
    final maxTemps = json['temperature_2m_max'] as List<dynamic>;
    final minTemps = json['temperature_2m_min'] as List<dynamic>;
    final precipProbs = json['precipitation_probability_max'] as List<dynamic>;
    final codes = json['weathercode'] as List<dynamic>;

    return List.generate(
      times.length,
      (i) => OutlookWeather(
        date: DateTime.parse(times[i]),
        tempMax: (maxTemps[i] as num).toDouble(),
        tempMin: (minTemps[i] as num).toDouble(),
        precipitationProbability: (precipProbs[i] as num).toDouble(),
        weatherCode: codes[i] as int,
      ),
    );
  }
}

class OutlookAnalysis {
  final bool isRainySeason;
  final bool isDrySeason;
  final bool isHotSeason;
  final bool isColdSeason;
  final double averageTemperature;
  final double averagePrecipitation;
  final String recommendation;

  OutlookAnalysis({
    required this.isRainySeason,
    required this.isDrySeason,
    required this.isHotSeason,
    required this.isColdSeason,
    required this.averageTemperature,
    required this.averagePrecipitation,
    required this.recommendation,
  });

  static OutlookAnalysis analyze(List<OutlookWeather> weatherData) {
    if (weatherData.isEmpty) {
      return OutlookAnalysis(
        isRainySeason: false,
        isDrySeason: false,
        isHotSeason: false,
        isColdSeason: false,
        averageTemperature: 0,
        averagePrecipitation: 0,
        recommendation: 'No data available',
      );
    }

    final avgTemp =
        weatherData
            .map((w) => (w.tempMax + w.tempMin) / 2)
            .reduce((a, b) => a + b) /
        weatherData.length;

    final avgPrecip =
        weatherData
            .map((w) => w.precipitationProbability)
            .reduce((a, b) => a + b) /
        weatherData.length;

    final rainyDays = weatherData
        .where((w) => w.precipitationProbability > 50)
        .length;

    final rainyPercentage = rainyDays / weatherData.length;

    // More flexible thresholds to capture seasonal trends
    final isRainy = rainyPercentage > 0.30; // 30% of days are rainy
    final isDry =
        rainyPercentage < 0.15 &&
        avgPrecip < 30; // 15% of days are rainy and low avg precip
    final isHot = avgTemp > 22; // Avg temp > 22°C
    final isCold = avgTemp < 15; // Avg temp < 15°C

    String recommendationKey = 'moderate_weather';
    if (isRainy) {
      recommendationKey = 'rainy_season';
    } else if (isDry) {
      recommendationKey = 'dry_season';
    } else if (isHot) {
      recommendationKey = 'summer_heat';
    } else if (isCold) {
      recommendationKey = 'cold_season';
    }

    return OutlookAnalysis(
      isRainySeason: isRainy,
      isDrySeason: isDry,
      isHotSeason: isHot,
      isColdSeason: isCold,
      averageTemperature: avgTemp,
      averagePrecipitation: avgPrecip,
      recommendation: recommendationKey,
    );
  }
}
