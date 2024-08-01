import 'package:intl/intl.dart';

class Weather {
  final String weatherMain;
  final String weatherDescription;
  final String weatherIcon;
  final num mainTemp;
  final num mainFeelsLike;
  final num mainTempMax;
  final num mainTempMin;
  final num mainHumidity;
  final num visibility;
  final num windSpeed;
  final num windDegree;
  final num clouds;
  final String sysCountry;
  final String sysSunrise;
  final String sysSunset;
  final String cityName;

  Weather(
      {required this.weatherMain,
      required this.weatherDescription,
      required this.weatherIcon,
      required this.mainTemp,
      required this.mainFeelsLike,
      required this.mainTempMax,
      required this.mainTempMin,
      required this.mainHumidity,
      required this.visibility,
      required this.windSpeed,
      required this.windDegree,
      required this.clouds,
      required this.sysCountry,
      required this.sysSunrise,
      required this.sysSunset,
      required this.cityName});

  factory Weather.fromJson(Map<String, dynamic> json) {
    DateTime sunrise =
        DateTime.fromMillisecondsSinceEpoch(json["sys"]["sunrise"]* 1000, isUtc: true);

    DateTime sunset =
        DateTime.fromMillisecondsSinceEpoch(json["sys"]["sunset"]* 1000, isUtc: true);

    sunrise = sunrise.add(Duration(milliseconds: json["timezone"]*1000));
    sunset = sunset.add(Duration(milliseconds: json["timezone"]*1000));

    String sunriseFormatted = DateFormat("hh:mm a").format(sunrise);
    String sunsetFormatted = DateFormat("hh:mm a").format(sunset);

    return Weather(
        weatherMain: json["weather"][0]["main"],
        weatherDescription: json["weather"][0]["description"],
        weatherIcon: json["weather"][0]["icon"],
        mainTemp: json["main"]["temp"],
        mainFeelsLike: json["main"]["feels_like"],
        mainTempMax: json["main"]["temp_max"],
        mainTempMin: json["main"]["temp_min"],
        mainHumidity: json["main"]["humidity"],
        visibility: json["visibility"],
        windSpeed: json["wind"]["speed"],
        windDegree: json["wind"]["deg"],
        clouds: json["clouds"]["all"],
        sysCountry: json["sys"]["country"],
        sysSunrise: sunriseFormatted,
        sysSunset: sunsetFormatted,
        cityName: json["name"]);
  }
}

/*
{
    "coord": {
        "lon": 73.6918,
        "lat": 24.5712
    },
    "weather": [ ---> this is a list here 
        {
            "id": 803,
            "main": "Clouds",
            "description": "broken clouds",
            "icon": "04d"
        }
    ],
    "base": "stations",
    "main": {
        "temp": 299.65,
        "feels_like": 299.65,
        "temp_min": 299.65,
        "temp_max": 299.65,
        "pressure": 1000,
        "humidity": 77,
        "sea_level": 1000,
        "grnd_level": 936
    },
    "visibility": 10000,
    "wind": {
        "speed": 4.41,
        "deg": 238,
        "gust": 5.83
    },
    "clouds": {
        "all": 53
    },
    "dt": 1722345560,
    "sys": {
        "type": 1,
        "id": 9072,
        "country": "IN",
        "sunrise": 1722299554,
        "sunset": 1722347434
    },
    "timezone": 19800,
    "id": 1253986,
    "name": "Udaipur",
    "cod": 200
}
*/
