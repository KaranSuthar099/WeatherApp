import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  final String _baseUrl = "https://api.openweathermap.org/data/2.5/weather?";

  Future<Weather> getWeather(String city) async {
    final response = await http.get(
        Uri.parse("${_baseUrl}q=$city&appid=c9fab1ff7a08753415cd473bb2497a83"));

    // https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}

    print("${_baseUrl}q=$city&appid=c9fab1ff7a08753415cd473bb2497a83");

    if (response.statusCode == 200) {
      // success
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      // error
      return throw Exception("An Error Occured while fetching an Location ");
    }
  }

  Future<String> getCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // get the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var location =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(location[0].locality);

    return location[0].locality ?? "Unknown";
  }
}
