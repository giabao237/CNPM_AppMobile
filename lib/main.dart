import 'package:flutter/material.dart';
import 'services/weather_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService weatherService = WeatherService();

  String city = "";
  String weather = "";
  double temp = 0;

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  Future<void> loadWeather() async {
    final data = await weatherService.getWeather();

    setState(() {
      city = data["city"];
      weather = data["weather"];
      temp = data["temp"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather App")),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$temp °C",
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),

            Text(city, style: const TextStyle(fontSize: 24)),

            Text(weather, style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}