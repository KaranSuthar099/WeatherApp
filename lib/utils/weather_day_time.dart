import 'package:intl/intl.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherDayTime {
  static DateTime _sunsetDateTime(Weather weather) {
    DateTime currentTime = DateTime.now();

    DateFormat format = DateFormat("hh:mm a");
    DateTime sunsetFormatted = format.parse(weather.sysSunset);

    DateTime todaySunset = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        sunsetFormatted.hour,
        sunsetFormatted.minute,
        sunsetFormatted.second);

    return todaySunset;
  }

  static DateTime _sunriseDateTime(Weather weather) {
    DateTime currentTime = DateTime.now();

    DateFormat format = DateFormat("hh:mm a");
    DateTime sunriseFormatted = format.parse(weather.sysSunrise);

    DateTime todaySunrise = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        sunriseFormatted.hour,
        sunriseFormatted.minute,
        sunriseFormatted.second);

    return todaySunrise;
  }

  static String getRemainingDayTime(Weather weather) {
    Duration duration = getRemainingDayTimeDuration(weather);
    return "${(duration.inHours > 0) ? duration.inHours : duration.inHours * -1}";
  }

  static Duration _dayDuration(Weather weather) {
    DateTime sunrise = _sunriseDateTime(weather);
    DateTime sunset = _sunsetDateTime(weather);

    Duration dayDuration = sunset.difference(sunrise);
    return dayDuration;
  }

  static Duration getRemainingDayTimeDuration(Weather weather) {
    DateTime currentTime = DateTime.now();
    Duration duration = currentTime.difference(_sunsetDateTime(weather));

    return duration;
  }

  static double dayConsumedPercentage(Weather weather) {
    DateTime sunrise = _sunriseDateTime(weather);
    DateTime current = DateTime.now();

    Duration dayConsumedDuration = current.difference(sunrise);

    Duration dayDuration = _dayDuration(weather);

    double percentage = (dayConsumedDuration.inHours / dayDuration.inHours);

    return percentage;
  }
}
