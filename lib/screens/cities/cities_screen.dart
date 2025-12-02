import 'package:flutter/material.dart';
import '../../core/api/weather_api.dart';
import '../../models/current_weather.dart';
import '../forecast/forecast_screen.dart';

class CitiesScreen extends StatefulWidget {
  const CitiesScreen({super.key});

  @override
  State<CitiesScreen> createState() => _CitiesScreenState();
}

class _CitiesScreenState extends State<CitiesScreen> {
  final List<String> cities = [
    "London",
    "Paris",
    "Berlin",
    "Dubai",
    "Tokyo",
    "New York",
  ];

  List<CurrentWeather> weatherData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  Future<void> loadWeather() async {
    List<CurrentWeather> results = [];

    for (String city in cities) {
      final data = await WeatherApi.getCurrentWeather(city);
      results.add(data);
    }

    setState(() {
      weatherData = results;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cities")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: weatherData.length,
              itemBuilder: (context, index) {
                final item = weatherData[index];

                return ListTile(
                  leading: Image.network(item.iconUrl),
                  title: Text(item.cityName),
                  subtitle: Text("${item.temperature}°C — ${item.condition}"),
                  // 🔽 Your "More Info" button goes here
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ForecastScreen(city: item.cityName),
                        ),
                      );
                    },
                    child: const Text("More Info"),
                  ),
                );
              },
            ),
    );
  }
}
