import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TempUnit { celsius, fahrenheit }

class UnitProvider extends ChangeNotifier {
  static const _unitKey = 'tempUnit';
  TempUnit _unit = TempUnit.celsius;
  TempUnit get unit => _unit;

  UnitProvider() {
    _loadUnit();
  }

  void toggleUnit() {
    _unit = _unit == TempUnit.celsius ? TempUnit.fahrenheit : TempUnit.celsius;
    _saveUnit();
    notifyListeners();
  }

  Future<void> _loadUnit() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_unitKey);
    if (value == 'fahrenheit') {
      _unit = TempUnit.fahrenheit;
    } else {
      _unit = TempUnit.celsius;
    }
    notifyListeners();
  }

  Future<void> _saveUnit() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _unitKey,
      _unit == TempUnit.celsius ? 'celsius' : 'fahrenheit',
    );
  }
}
