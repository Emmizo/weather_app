import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/api/api_client.dart';
import '../../core/api/endpoints.dart';
import '../../core/models/daily_weather.dart';
import '../../core/models/hourly_weather.dart';
import '../../core/utils/error_handler.dart';
import '../../core/models/location.dart';
import '../../core/models/hourly_air_quality.dart';
import '../../core/models/weather.dart';
import '../../core/models/forecast_outlook.dart';
import 'dart:convert';

class ForecastProvider extends ChangeNotifier {
  bool _loading = false;
  String? _error;
  List<DailyWeather>? _dailyForecasts;
  List<HourlyWeather>? _hourlyForecasts;
  List<HourlyAirQuality>? _hourlyAirQuality;
  OutlookAnalysis? _outlookAnalysis;
  Weather? _currentWeather;
  int _selectedDay = 0;

  bool get loading => _loading;
  String? get error => _error;
  List<DailyWeather>? get dailyForecasts => _dailyForecasts;
  List<HourlyWeather>? get hourlyForecasts => _hourlyForecasts;
  List<HourlyAirQuality>? get hourlyAirQuality => _hourlyAirQuality;
  OutlookAnalysis? get outlookAnalysis => _outlookAnalysis;
  Weather? get currentWeather => _currentWeather;
  int get selectedDay => _selectedDay;

  void selectDay(int index) {
    if (index >= 0 &&
        _dailyForecasts != null &&
        index < _dailyForecasts!.length) {
      _selectedDay = index;
      notifyListeners();
    }
  }

  Future<void> fetchForecast(Location location, {int dailyDays = 7}) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final shortTermUrl =
          'https://api.open-meteo.com/v1/forecast?latitude=${location.latitude}&longitude=${location.longitude}&current_weather=true&hourly=temperature_2m,precipitation_probability,weathercode,windspeed_10m&daily=temperature_2m_max,temperature_2m_min,weathercode,sunrise,sunset&timezone=auto&forecast_days=$dailyDays';
      final outlookUrl = Endpoints.sixteenDayForecast(
        location.latitude,
        location.longitude,
      );
      final airQualityUrl =
          'https://air-quality-api.open-meteo.com/v1/air-quality?latitude=${location.latitude}&longitude=${location.longitude}&hourly=pm10,pm2_5,european_aqi&timezone=auto';

      final responses = await Future.wait([
        ApiClient().get(shortTermUrl),
        ApiClient().get(outlookUrl),
        ApiClient().get(airQualityUrl),
      ]);

      // Main forecast (critical)
      final shortTermResponse = responses[0];
      if (shortTermResponse.statusCode == 200) {
        final data = json.decode(shortTermResponse.body);
        final dailyData = data['daily'];
        final hourlyData = data['hourly'];
        final windSpeeds = (hourlyData['windspeed_10m'] as List<dynamic>?)
            ?.map((s) => s != null ? (s as num).toDouble() : null)
            .toList();

        _dailyForecasts = DailyWeather.fromDailyJsonWithWind(
          dailyData,
          windSpeeds ?? [],
        );
        _hourlyForecasts = HourlyWeather.fromHourlyJson(hourlyData);
        _currentWeather = Weather.fromJson(data);
        _selectedDay = 0;
      } else {
        throw Exception(
          'Failed to fetch weather data: ${shortTermResponse.body}',
        );
      }

      // 16-Day Outlook (non-critical)
      final outlookResponse = responses[1];
      if (outlookResponse.statusCode == 200) {
        final data = json.decode(outlookResponse.body);
        final outlookForecasts = OutlookWeather.fromJson(data['daily']);
        _outlookAnalysis = OutlookAnalysis.analyze(outlookForecasts);
      } else {
        debugPrint('Failed to fetch 16-day outlook: ${outlookResponse.body}');
        _outlookAnalysis = null;
      }

      // Air quality (non-critical)
      final airQualityResponse = responses[2];
      if (airQualityResponse.statusCode == 200) {
        final data = json.decode(airQualityResponse.body);
        _hourlyAirQuality = HourlyAirQuality.fromJson(data['hourly']);
      } else {
        debugPrint(
          'Failed to fetch air quality data: ${airQualityResponse.body}',
        );
        _hourlyAirQuality = null;
      }
    } catch (e, stackTrace) {
      _error = ErrorHandler.getErrorMessage(e);
      debugPrint('Error in fetchForecast: $e');
      debugPrint(stackTrace.toString());
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
