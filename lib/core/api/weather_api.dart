import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/api_keys.dart';
import '../../models/current_weather.dart';
import '../../models/forecast_day.dart';
import '../../models/hourly_weather.dart';

class WeatherApi {
  static const String _baseUrl = 'https://api.weatherapi.com/v1';

  // ---------------- CITY WEATHER ----------------
  static Future<CurrentWeather> getCurrentWeather(String city) async {
    final url = Uri.parse(
      '$_baseUrl/current.json?key=${ApiKeys.weatherApiKey}&q=$city',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load current weather');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return CurrentWeather.fromJson(data);
  }

  // ---------------- GPS WEATHER ----------------
  static Future<CurrentWeather> getWeatherByCoordinates(
    double lat,
    double lon,
  ) async {
    final url = Uri.parse(
      '$_baseUrl/current.json?key=${ApiKeys.weatherApiKey}&q=$lat,$lon',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load location weather');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return CurrentWeather.fromJson(data);
  }

  // ---------------- 3-DAY FORECAST ----------------
  static Future<List<ForecastDay>> get3DayForecast(String city) async {
    final url = Uri.parse(
      '$_baseUrl/forecast.json?key=${ApiKeys.weatherApiKey}&q=$city&days=3',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load 3-day forecast');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> days = data['forecast']['forecastday'];

    return days
        .map((dayJson) => ForecastDay.fromJson(dayJson))
        .toList();
  }

  // ---------------- HOURLY FORECAST ----------------
  static Future<List<HourlyWeather>> getHourly(String city) async {
    final url = Uri.parse(
      '$_baseUrl/forecast.json?key=${ApiKeys.weatherApiKey}&q=$city&hours=24',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load hourly forecast');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> hours = data['forecast']['forecastday'][0]['hour'];

    return hours
        .map((hourJson) => HourlyWeather.fromJson(hourJson))
        .toList();
  }
}
