import 'package:flutter/material.dart';
import '../../core/api/weather_api.dart';
import '../../models/current_weather.dart';
import '../cities/cities_screen.dart'; // YOU NEED THIS IMPORT

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CurrentWeather? weather;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    setState(() => loading = true);

    try {
      final result = await WeatherApi.getCurrentWeather("London");
      setState(() {
        weather = result;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      print("ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Breeze"),
      ),
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : weather == null
                ? const Text("Failed to load weather.")
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        weather!.cityName,
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${weather!.temperature}°C",
                        style: const TextStyle(fontSize: 40),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        weather!.condition,
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(height: 20),
                      Image.network(weather!.iconUrl),

                      // ✅ BUTTON ADDED HERE — EXACT PLACE YOU NEED
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CitiesScreen()),
                          );
                        },
                        child: const Text("Choose City"),
                      ),
                    ],
                  ),
      ),
    );
  }
}

