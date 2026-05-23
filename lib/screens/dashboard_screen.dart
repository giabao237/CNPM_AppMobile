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
      
      //appBar: AppBar(
  // Truyền vào 1 Widget Column để xếp các dòng chữ theo chiều dọc
  //title: Column(
   // crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái cho các dòng chữ
    //children: [
     // Text(
        //"Xin chào $username",
       // style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
   //   ),
    //  Text(
    //    "hello $username",
    //   style: const TextStyle(fontSize: 14, color: Colors.grey), // Dòng dưới nhỏ hơn, màu xám
   //   ),
 //   ],
//  ),
//),

      body: const WeatherScreen(), //gọi giao diện của weather_screen.dart
    );
  }
}