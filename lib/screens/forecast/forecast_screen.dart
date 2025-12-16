
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/api/weather_api.dart';
import '../../models/forecast_day.dart';
import '../hourly/hourly_screen.dart';
import '../../widgets/app_drawer.dart';

class ForecastScreen extends StatefulWidget {
  final String city;

  const ForecastScreen({super.key, required this.city});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  List<ForecastDay> forecast = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadForecast();
  }

  Future<void> loadForecast() async {
    try {
      final result = await WeatherApi.get3DayForecast(widget.city);
      setState(() {
        forecast = result;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      // ignore: avoid_print
      print("FORECAST ERROR: $e");
    }
  }

  Future<void> _openWeatherMap() async {
    final uri = Uri.parse(
      'https://www.weatherapi.com/weather/q/${Uri.encodeComponent(widget.city)}',
    );

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      print('Could not open weather map');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: Text("${widget.city} — 3-Day Forecast"),
      centerTitle: true,
        backgroundColor: Colors.blue),
      drawer: const AppDrawer(),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: forecast.length,
                    itemBuilder: (context, index) {
                      final day = forecast[index];
                      return ListTile(
                        leading: Image.network(day.iconUrl),
                        title: Text(day.date),
                        subtitle: Text(
                          "${day.condition}\nMax: ${day.maxTemp}°C   Min: ${day.minTemp}°C",
                        ),
                      );
                    },
                  ),
                ),

                // bottom buttons: map + hourly
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                             backgroundColor: Colors.blue,
                              foregroundColor: Colors.white
                              ),
                          onPressed: _openWeatherMap,
                          child: const Text("Open Weather Map"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    HourlyScreen(city: widget.city),
                              ),
                            );
                          },
                          child: const Text("View Hourly Forecast"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

