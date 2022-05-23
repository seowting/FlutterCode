import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class WeatherProvider with ChangeNotifier {
  String _desc = "";
  String get desc => _desc;

void getProvider(String location) async {
    var apiid = "54c4d5ffd3cff85b55e7fb8a20778ab0";
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiid&units=metric');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = response.body;
      var parsedData = json.decode(jsonData);
      var temperature = parsedData['main']['temp'];
      var humidity = parsedData['main']['humidity'];
      var weather = parsedData['weather'][0]['main'];
      var feelslike = parsedData['main']['feels_like'];
      var loc = parsedData['name'];
      _desc = "Current weather data in " +
          loc.toString() +
          " is " +
          weather.toString() +
          " with temperature of " +
          temperature.toString() +
          " celcius and " +
          humidity.toString() +
          "% humidity. It's feel like " +
          feelslike.toString();
          notifyListeners();
    }
  }
}