import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/Model/Weatherdata.dart';

class Weatherservice {
  final TextEditingController _controller = TextEditingController();

  fetchWeather(String city) async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=b17741d0546e5faf64b5f0d002f9b818"));
    try {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        await saveWeatherData(json);
        return WeatherData.fromJson(json);
      } else {
        throw Exception("Failed to load weather data");
      }
    } catch (e) {
      print(e.toString());
      throw Exception("Failed to load weather data");
    }
  }

  Future<void> saveWeatherData(Map<String, dynamic> json) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('weatherData', jsonEncode(json));
  }

  Future<WeatherData?> getSavedWeatherData() async {
    final prefs = await SharedPreferences.getInstance();
    String? weatherDataString = prefs.getString('weatherData');
    if (weatherDataString != null) {
      var json = jsonDecode(weatherDataString);
      return WeatherData.fromJson(json);
    }
    return null;
  }

  TextEditingController get controller => _controller;
}
