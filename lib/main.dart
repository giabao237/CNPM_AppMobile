import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/speed_screen.dart';
import 'screens/step_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: const LoginScreen(),
      home: const StepScreen(),
    );
  }
}
