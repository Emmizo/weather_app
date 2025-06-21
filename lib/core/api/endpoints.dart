class Endpoints {
  static String geocoding(String city) =>
      'https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1';

  static String forecast(double latitude, double longitude) =>
      'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true';

  static String forecastWithHourly(double latitude, double longitude) =>
      'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true&hourly=temperature_2m,precipitation_probability,weathercode,windspeed_10m&timezone=auto&forecast_days=2';

  static String sixteenDayForecast(double latitude, double longitude) =>
      'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max,weathercode&timezone=auto&forecast_days=16';

  static String airQuality(double latitude, double longitude) =>
      'https://air-quality-api.open-meteo.com/v1/air-quality?latitude=$latitude&longitude=$longitude&hourly=pm10,pm2_5,european_aqi&timezone=auto';
}
