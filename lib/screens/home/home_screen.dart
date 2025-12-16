import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/weather_provider.dart';
import '../cities/cities_screen.dart';
import '../../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchWeather("London");
    });
  }

 
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text("Breeze"),
      centerTitle: true,
        backgroundColor: Colors.blue),
      body: Center(
        child: provider.isLoading
            ? const CircularProgressIndicator()
            : provider.currentWeather == null
                ? const Text("Failed to load weather.")
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        provider.currentWeather!.cityName,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${provider.currentWeather!.temperature}°C",
                        style: const TextStyle(fontSize: 40),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        provider.currentWeather!.condition,
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(height: 20),
                      Image.network(provider.currentWeather!.iconUrl),

                      const SizedBox(height: 30),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CitiesScreen(),
                            ),
                          );
                        },
                        child: const Text("Choose City"),
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                         ),
                        onPressed: () {
                          context
                              .read<WeatherProvider>()
                              .fetchWeatherByLocation();
                        },
                        child: const Text("Use My Location"),
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                         ),
                          onPressed: provider.latitude == null || provider.longitude == null
                              ? null
                              : () async {
                                  final lat = provider.latitude!;
                                  final lon = provider.longitude!;

                                  final url = Uri.parse(
                                    "https://www.google.com/maps/search/?api=1&query=$lat,$lon",
                                  );

                                  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                                    debugPrint("Could not open map");
                                  }
                                },
                          child: const Text("Show Weather Map"),
                        ),


                    ],
                  ),
      ),
    );
  }
}
