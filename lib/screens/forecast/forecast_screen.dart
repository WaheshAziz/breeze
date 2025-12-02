import 'package:flutter/material.dart';
import '../../core/api/weather_api.dart';
import '../../models/forecast_day.dart';
import '../hourly/hourly_screen.dart';

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
      print("FORECAST ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.city} — 3-Day Forecast")),
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

                // ---------- HOURLY FORECAST BUTTON ----------
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
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
    );
  }
}
