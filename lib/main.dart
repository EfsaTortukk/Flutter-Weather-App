import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherApp(),
    );
  }
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final List<String> cities = ['Mersin', 'Porto', 'Torino', 'Hatay', 'Gaziantep'];
  Map<String, dynamic> weatherData = {};

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    for (final city in cities) {
      final response = await http.get(
        Uri.parse('https://weatherapi-com.p.rapidapi.com/current.json?q=$city'),
        headers: {
          'X-RapidAPI-Key': '17e513c9a8mshd9cba8c24f63a2ep106520jsn7a647aa14f46',
          'X-RapidAPI-Host': 'weatherapi-com.p.rapidapi.com',
        },
      );
      final data = json.decode(response.body);
      setState(() {
        weatherData[city] = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, index) {
          final city = cities[index];
          final data = weatherData[city];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Location: $city', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.0),
                  Text('Temperature: ${data['current']['temp_c']}°C'),
                  Text('Humidity: ${data['current']['humidity']}%'),
                  Text('Wind Speed: ${data['current']['wind_kph']} km/h'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
