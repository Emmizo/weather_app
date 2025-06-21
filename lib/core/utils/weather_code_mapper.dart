class WeatherCodeMapper {
  static const Map<int, String> descriptions = {
    0: 'Clear sky',
    1: 'Mainly clear',
    2: 'Partly cloudy',
    3: 'Overcast',
    45: 'Fog',
    48: 'Depositing rime fog',
    51: 'Light drizzle',
    53: 'Moderate drizzle',
    55: 'Dense drizzle',
    56: 'Light freezing drizzle',
    57: 'Dense freezing drizzle',
    61: 'Slight rain',
    63: 'Moderate rain',
    65: 'Heavy rain',
    66: 'Light freezing rain',
    67: 'Heavy freezing rain',
    71: 'Slight snow fall',
    73: 'Moderate snow fall',
    75: 'Heavy snow fall',
    77: 'Snow grains',
    80: 'Slight rain showers',
    81: 'Moderate rain showers',
    82: 'Violent rain showers',
    85: 'Slight snow showers',
    86: 'Heavy snow showers',
    95: 'Thunderstorm',
    96: 'Thunderstorm with slight hail',
    99: 'Thunderstorm with heavy hail',
  };

  static String description(int code) {
    return descriptions[code] ?? 'Unknown';
  }

  static String icon(int code) {
    if (code == 0) return '☀️';
    if (code == 1) return '🌤️';
    if (code == 2) return '⛅';
    if (code == 3) return '☁️';
    if (code == 45 || code == 48) return '🌫️';
    if (code >= 51 && code <= 57) return '🌦️';
    if (code >= 61 && code <= 67) return '🌧️';
    if (code >= 71 && code <= 77) return '❄️';
    if (code >= 80 && code <= 82) return '🌦️';
    if (code >= 85 && code <= 86) return '🌨️';
    if (code == 95) return '⛈️';
    if (code == 96 || code == 99) return '⛈️';
    return '❔';
  }

  /// Returns the background image asset path based on weather code and hour.
  static String background(int weatherCode, int hour) {
    // Day: 6-18, Night: otherwise
    final isDay = hour >= 6 && hour < 18;
    if (weatherCode == 0) {
      return isDay
          ? 'assets/images/backgrounds/clear_day.jpg'
          : 'assets/images/backgrounds/clear_night.jpg';
    } else if ([1, 2, 3, 45, 48].contains(weatherCode)) {
      return isDay
          ? 'assets/images/backgrounds/cloudy_day.jpg'
          : 'assets/images/backgrounds/cloudy_night.jpg';
    } else if ([
      51,
      53,
      55,
      56,
      57,
      61,
      63,
      65,
      66,
      67,
      80,
      81,
      82,
    ].contains(weatherCode)) {
      return 'assets/images/backgrounds/rain.jpg';
    } else if ([71, 73, 75, 77, 85, 86].contains(weatherCode)) {
      return 'assets/images/backgrounds/snow.jpg';
    } else if ([95, 96, 99].contains(weatherCode)) {
      return 'assets/images/backgrounds/thunderstorm.jpg';
    }
    return isDay
        ? 'assets/images/backgrounds/clear_day.jpg'
        : 'assets/images/backgrounds/clear_night.jpg';
  }

  /// Check if weather code represents rainy conditions
  static bool isRainy(int code) {
    return [
      51,
      53,
      55,
      56,
      57,
      61,
      63,
      65,
      66,
      67,
      80,
      81,
      82,
      95,
      96,
      99,
    ].contains(code);
  }

  /// Check if weather code represents heavy rain
  static bool isHeavyRain(int code) {
    return [65, 67, 82].contains(code);
  }

  /// Check if weather code represents a thunderstorm
  static bool isThunderstorm(int code) {
    return [95, 96, 99].contains(code);
  }

  /// Check if weather code represents sunny conditions
  static bool isSunny(int code) {
    return [0, 1].contains(code);
  }

  /// Check if weather code represents cloudy conditions
  static bool isCloudy(int code) {
    return [2, 3, 45, 48].contains(code);
  }

  /// Check if weather code represents snowy conditions
  static bool isSnowy(int code) {
    return [71, 73, 75, 77, 85, 86].contains(code);
  }
}
