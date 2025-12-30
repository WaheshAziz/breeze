
import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/cities/cities_screen.dart';
import '../screens/forecast/forecast_screen.dart';
import '../screens/hourly/hourly_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _go(BuildContext context, Widget page) {
    Navigator.pop(context); // close drawer
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ListTile(
              title: Text(
                "Breeze",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Weather App"),
            ),
            const Divider(),

            //  Home
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () => _go(context, const HomeScreen()),
            ),

            // Cities
            ListTile(
              leading: const Icon(Icons.location_city),
              title: const Text("Cities"),
              onTap: () => _go(context, const CitiesScreen()),
            ),

            const Divider(),

            // 3-Day Forecast (default: London)
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text("3-Day Forecast"),
              onTap: () => _go(
                context,
                ForecastScreen(city: "London"),
              ),
            ),

            // Hourly Forecast (default: London)
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text("Hourly Forecast"),
              onTap: () => _go(
                context,
                HourlyScreen(city: "London"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
