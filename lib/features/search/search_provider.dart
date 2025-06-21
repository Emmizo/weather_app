import 'package:flutter/material.dart';
import 'dart:convert';
import '../../core/api/api_client.dart';
import '../../core/api/endpoints.dart';
import '../../core/models/location.dart';
import '../../core/utils/error_handler.dart';

class SearchProvider extends ChangeNotifier {
  bool _loading = false;
  String? _error;
  Location? _location;

  bool get loading => _loading;
  String? get error => _error;
  Location? get location => _location;

  void setLocation(Location location) {
    _location = location;
    notifyListeners();
  }

  Future<void> searchCity(String city) async {
    _loading = true;
    _error = null;
    _location = null;
    notifyListeners();
    try {
      final response = await ApiClient().get(Endpoints.geocoding(city));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final location = Location.fromJson(data);
        _location = location;
      } else {
        _error = 'City not found';
      }
    } catch (e) {
      _error = ErrorHandler.getErrorMessage(e);
    }
    _loading = false;
    notifyListeners();
  }
}
