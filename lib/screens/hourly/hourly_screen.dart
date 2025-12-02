import 'package:flutter/material.dart';
import '../../core/api/weather_api.dart';
import '../../models/hourly_weather.dart';

class HourlyScreen extends StatefulWidget {
  final String city;

  const HourlyScreen({super.key, required this.city});

  @override
  State<HourlyScreen> createState() => _HourlyScreenState();
}

class _HourlyScreenState extends State<HourlyScreen> {
  bool loading = true;
  List<HourlyWeather> hours = [];

  @override
  void initState() {
    super.initState();
    loadHours();
  }

  Future<void> loadHours() async {
    try {
      final data = await WeatherApi.getHourly(widget.city);
      setState(() {
        hours = data;
        loading = false;
      });
    } catch (e) {
      loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hourly - ${widget.city}")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: hours.length,
              itemBuilder: (context, index) {
                final hour = hours[index];
                return ListTile(
                  leading: Image.network(hour.iconUrl),
                  title: Text("${hour.time}"),
                  subtitle: Text("${hour.condition}"),
                trailing: Text("${hour.temp}°C"),
                );
              },
            ),
    );
  }
}
