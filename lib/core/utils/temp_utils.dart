import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/core/utils/unit_provider.dart';

class TempUtils {
  static double cToF(double c) => c * 9 / 5 + 32;

  static String formatTemperature(double tempC, BuildContext context) {
    final unitProvider = context.read<UnitProvider>();
    if (unitProvider.unit == TempUnit.fahrenheit) {
      final tempF = cToF(tempC);
      return '${tempF.round()}°F';
    }
    return '${tempC.round()}°C';
  }
}
