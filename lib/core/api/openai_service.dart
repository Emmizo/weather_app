import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_keys.dart';
import '../models/weather.dart';
import '../models/hourly_weather.dart';
import '../models/daily_weather.dart';
import '../models/hourly_air_quality.dart';

class OpenAIService {
  static final OpenAIService _instance = OpenAIService._internal();
  factory OpenAIService() => _instance;
  OpenAIService._internal();

  final http.Client _client = http.Client();

  static const String _agriAdvisorSystemPrompt =
      'You are an Agricultural Weather Advisor specialized in helping farmers make informed decisions based on short-term and long-term weather forecasts. Your job is to interpret weather data in simple, actionable language. You give advice on crop planting, irrigation, fertilizer use, pest prevention, and harvest timing, based on location, season, and crop type. Use local context and be clear, friendly, and practical. Translate to Kinyarwanda if requested. Always prioritize farmer safety and productivity.';

  Future<String> generateWeatherInsights({
    required Weather currentWeather,
    required List<HourlyWeather> hourlyForecasts,
    required List<DailyWeather> dailyForecasts,
    required HourlyAirQuality? airQuality,
    required String locationName,
    required String languageCode,
  }) async {
    try {
      final prompt = _buildWeatherPrompt(
        currentWeather: currentWeather,
        hourlyForecasts: hourlyForecasts,
        dailyForecasts: dailyForecasts,
        airQuality: airQuality,
        locationName: locationName,
        languageCode: languageCode,
      );

      final response = await _client.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAiApiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'system', 'content': _agriAdvisorSystemPrompt},
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] ??
            'Unable to generate insights at this time.';
      } else {
        return 'Weather insights temporarily unavailable.';
      }
    } catch (e) {
      return 'Weather insights temporarily unavailable.';
    }
  }

  Future<String> generateActivityRecommendations({
    required Weather currentWeather,
    required List<HourlyWeather> hourlyForecasts,
    required HourlyAirQuality? airQuality,
    required String languageCode,
  }) async {
    try {
      final prompt = _buildActivityPrompt(
        currentWeather: currentWeather,
        hourlyForecasts: hourlyForecasts,
        airQuality: airQuality,
        languageCode: languageCode,
      );

      final response = await _client.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAiApiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'system', 'content': _agriAdvisorSystemPrompt},
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': 300,
          'temperature': 0.8,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] ??
            'Unable to generate recommendations at this time.';
      } else {
        return 'Activity recommendations temporarily unavailable.';
      }
    } catch (e) {
      return 'Activity recommendations temporarily unavailable.';
    }
  }

  Future<String> generateClothingRecommendations({
    required Weather currentWeather,
    required List<HourlyWeather> hourlyForecasts,
    required String languageCode,
  }) async {
    try {
      final prompt = _buildClothingPrompt(
        currentWeather: currentWeather,
        hourlyForecasts: hourlyForecasts,
        languageCode: languageCode,
      );

      final response = await _client.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAiApiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'system', 'content': _agriAdvisorSystemPrompt},
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': 250,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] ??
            'Unable to generate clothing recommendations at this time.';
      } else {
        return 'Clothing recommendations temporarily unavailable.';
      }
    } catch (e) {
      return 'Clothing recommendations temporarily unavailable.';
    }
  }

  String _buildWeatherPrompt({
    required Weather currentWeather,
    required List<HourlyWeather> hourlyForecasts,
    required List<DailyWeather> dailyForecasts,
    required HourlyAirQuality? airQuality,
    required String locationName,
    required String languageCode,
  }) {
    final currentTemp = currentWeather.temperature;
    final currentCondition = currentWeather.weathercode;
    final windSpeed = currentWeather.windspeed;

    final next24Hours = hourlyForecasts
        .take(24)
        .map(
          (w) =>
              '${w.time.hour}:00 - ${w.temperature}°C, ${w.weatherCode}, Wind: ${w.windSpeed ?? 0}km/h',
        )
        .join('\n');

    final next7Days = dailyForecasts
        .take(7)
        .map(
          (w) =>
              '${w.date.day}/${w.date.month} - ${w.tempMax}°C/${w.tempMin}°C, ${w.weatherCode}',
        )
        .join('\n');

    final airQualityInfo = airQuality != null
        ? 'Air Quality Index: ${airQuality.aqi}, PM2.5: ${airQuality.pm2_5}, PM10: ${airQuality.pm10}'
        : 'Air quality data not available';

    final languageInstruction = _getLanguageInstruction(languageCode);

    return '''
$languageInstruction

Current weather in $locationName:
- Temperature: ${currentTemp}°C
- Condition: ${currentCondition}
- Wind Speed: ${windSpeed} km/h
- $airQualityInfo

Next 24 hours forecast:
$next24Hours

Next 7 days forecast:
$next7Days

Please provide:
1. A brief weather summary for today
2. Any weather alerts or warnings
3. Tips for staying comfortable in these conditions
4. What to expect in the coming days
''';
  }

  String _buildActivityPrompt({
    required Weather currentWeather,
    required List<HourlyWeather> hourlyForecasts,
    required HourlyAirQuality? airQuality,
    required String languageCode,
  }) {
    final temp = currentWeather.temperature;
    final condition = currentWeather.weathercode;
    final windSpeed = currentWeather.windspeed;
    final aqi = airQuality?.aqi ?? 0;

    final languageInstruction = _getLanguageInstruction(languageCode);

    return '''
$languageInstruction

Current conditions:
- Temperature: ${temp}°C
- Weather: ${condition}
- Wind: ${windSpeed} km/h
- Air Quality: $aqi

Suggest 3-5 activities (both indoor and outdoor) that would be enjoyable and safe in these conditions.
''';
  }

  String _buildClothingPrompt({
    required Weather currentWeather,
    required List<HourlyWeather> hourlyForecasts,
    required String languageCode,
  }) {
    final temp = currentWeather.temperature;
    final condition = currentWeather.weathercode;
    final windSpeed = currentWeather.windspeed;

    final tempRange = hourlyForecasts.map((w) => w.temperature);
    final minTemp = tempRange.reduce((a, b) => a < b ? a : b);
    final maxTemp = tempRange.reduce((a, b) => a > b ? a : b);

    final languageInstruction = _getLanguageInstruction(languageCode);

    return '''
$languageInstruction

Weather conditions:
- Current: ${temp}°C
- Range today: ${minTemp}°C to ${maxTemp}°C
- Weather: ${condition}
- Wind: ${windSpeed} km/h

Suggest appropriate clothing for these conditions, considering the temperature range and weather conditions.
''';
  }

  String _getLanguageInstruction(String languageCode) {
    switch (languageCode) {
      case 'fr':
        return 'IMPORTANT: Please respond in French (Français).';
      case 'rw':
        return 'IMPORTANT: Please respond in Kinyarwanda (Ikinyarwanda).';
      case 'en':
      default:
        return 'IMPORTANT: Please respond in English.';
    }
  }

  void dispose() {
    _client.close();
  }

  // --- New Agricultural Prompt Builders ---

  String buildGeneralForecastAdvicePrompt({
    required String crop,
    required String district,
    required String weatherData,
    required String languageCode,
  }) {
    final languageInstruction = _getLanguageInstruction(languageCode);
    return '''
$languageInstruction

Based on this 5-day weather forecast for $crop farmers in $district, what advice would you give about planting, irrigation, and disease risks?
Weather data: $weatherData
''';
  }

  String buildNotificationAlertPrompt({
    required String location,
    required String alertType,
    required String languageCode,
  }) {
    final languageInstruction = _getLanguageInstruction(languageCode);
    return '''
$languageInstruction

Generate an SMS alert in simple language for farmers in $location warning them about $alertType. Include crop safety tips. Limit to 160 characters.
''';
  }

  String buildFertilizerDecisionPrompt({
    required String crop,
    required String forecastSummary,
    required String day,
    required String languageCode,
  }) {
    final languageInstruction = _getLanguageInstruction(languageCode);
    return '''
$languageInstruction

The weather forecast for this week shows $forecastSummary. Should $crop farmers apply fertilizer on $day, or wait until after the rain?
''';
  }

  String buildPestDiseaseAlertPrompt({
    required String crop,
    required String location,
    required String weatherCondition,
    required String languageCode,
  }) {
    final languageInstruction = _getLanguageInstruction(languageCode);
    return '''
$languageInstruction

If $weatherCondition, what pest or disease risks should $crop farmers in $location be aware of?
''';
  }

  /// Builds a warning prompt based on forecast severity, customizable for any weather risk.
  String buildWarningPrompt({
    required String rainfall,
    required String wind,
    required String temperature,
    required String humidity,
    required String location,
    required String crop,
    required String languageCode,
  }) {
    final languageInstruction = _getLanguageInstruction(languageCode);
    return '''
$languageInstruction

Based on the following weather forecast, generate a clear warning message for farmers. Highlight any risks such as flooding, strong winds, drought, or pest/disease conditions based on the severity of rainfall, temperature, humidity, or wind. Add a short, practical advice.
Forecast data:
Rainfall: $rainfall mm/day
Wind: $wind km/h
Temperature: $temperature°C
Humidity: $humidity%
Location: $location
Crop: $crop
''';
  }
}
