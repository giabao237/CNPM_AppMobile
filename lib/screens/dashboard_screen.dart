import 'package:flutter/material.dart';
import 'weather_screen.dart';

class DashboardScreen extends StatelessWidget {

  final String username;

  const DashboardScreen({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Xin chào $username"),
      ),

      body: const WeatherScreen(),
    );
  }
}