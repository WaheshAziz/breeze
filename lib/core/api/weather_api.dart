import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/api_keys.dart';
// we’ll create these models soon – for now you can comment them if needed.
import '../../models/current_weather.dart';
import '../../models/forecast_day.dart';
import '../../models/hourly_weather.dart';

class WeatherApi {
  static const String _baseUrl = 'https://api.weatherapi.com/v1';

  // Current weather for a single city
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

  // 3-day forecast for a city
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

  // Hourly forecast for the coming 24 hours
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
