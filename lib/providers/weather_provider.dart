import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../core/api/weather_api.dart';
import '../models/current_weather.dart';

class WeatherProvider extends ChangeNotifier {
  CurrentWeather? _currentWeather;
  bool _loading = false;

  double? _lat;
  double? _lon;

  CurrentWeather? get currentWeather => _currentWeather;
  bool get isLoading => _loading;
  double? get latitude => _lat;
  double? get longitude => _lon;

  // -------- CITY WEATHER --------
  Future<void> fetchWeather(String city) async {
    _loading = true;
    notifyListeners();

    try {
      _currentWeather = await WeatherApi.getCurrentWeather(city);
    } catch (e) {
      debugPrint("City weather error: $e");
    }

    _loading = false;
    notifyListeners();
  }

  // -------- GPS WEATHER --------
  Future<void> fetchWeatherByLocation() async {
    _loading = true;
    notifyListeners();

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _lat = position.latitude;
      _lon = position.longitude;

      _currentWeather = await WeatherApi.getWeatherByCoordinates(
        _lat!,
        _lon!,
      );
    } catch (e) {
      debugPrint("GPS weather error: $e");
    }

    _loading = false;
    notifyListeners();
  }
}
