import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location.dart';
import 'dart:convert';

class LocationsProvider extends ChangeNotifier {
  static const _locationsKey = 'savedLocations';
  static const _selectedKey = 'selectedLocation';

  List<Location> _locations = [];
  Location? _selected;

  List<Location> get locations => _locations;
  Location? get selected => _selected;

  LocationsProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final locs = prefs.getStringList(_locationsKey) ?? [];
    _locations = locs.map((e) => Location.fromJson(json.decode(e))).toList();
    final sel = prefs.getString(_selectedKey);
    if (sel != null) {
      _selected = Location.fromJson(json.decode(sel));
    } else if (_locations.isNotEmpty) {
      _selected = _locations.first;
    }
    notifyListeners();
  }

  Future<void> addLocation(Location location) async {
    if (_locations.any(
      (l) =>
          l.latitude == location.latitude && l.longitude == location.longitude,
    ))
      return;
    _locations.add(location);
    await _save();
    selectLocation(location);
  }

  Future<void> removeLocation(Location location) async {
    _locations.removeWhere(
      (l) =>
          l.latitude == location.latitude && l.longitude == location.longitude,
    );
    if (_selected != null &&
        _selected!.latitude == location.latitude &&
        _selected!.longitude == location.longitude) {
      _selected = _locations.isNotEmpty ? _locations.first : null;
    }
    await _save();
    notifyListeners();
  }

  Future<void> selectLocation(Location location) async {
    _selected = location;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedKey, json.encode(location.toJson()));
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _locationsKey,
      _locations.map((l) => json.encode(l.toJson())).toList(),
    );
  }
}
