import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/service/weather_service.dart';
import 'package:weather_app/utils/weather_day_time.dart';
import 'package:weather_app/utils/wind_direction_convertor.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final WeatherService _weatherService = WeatherService();

  // Weather? _weather;

  // fetch weather
  Future<Weather> _fetchWeather() async {
    // call the fet latlong funtion
    String city = await _weatherService.getCity();

    try {
      Weather weather = await _weatherService.getWeather(city);
      return weather;
    } catch (e) {
      print(e);
      print("retrying");
      return _fetchWeather();
    }
  }

  // weather animation

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: FutureBuilder(
          future: _fetchWeather(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return WeatherDisplay(weather: snapshot.data);
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

class WeatherDisplay extends StatelessWidget {
  const WeatherDisplay({
    super.key,
    required Weather? weather,
  }) : _weather = weather;

  final Weather? _weather;

  @override
  Widget build(BuildContext context) {
    if (_weather == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      children: [
        // city name and country name
        CityCountryTagWidget(weather: _weather),

        MainTemperatureWidget(weather: _weather),

        TemperatureDetailsWidget(weather: _weather),

        WindConditionsWidget(weather: _weather),

        HumidityWidget(weather: _weather),

        DayDurationWidget(weather: _weather),
      ],
    );
  }
}

class DayDurationWidget extends StatelessWidget {
  const DayDurationWidget({
    super.key,
    required Weather? weather,
  }) : _weather = weather;

  final Weather? _weather;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              Column(children: [
                const Icon(Icons.wb_sunny_rounded, color: Colors.amber),
                Text(
                  "${_weather!.sysSunrise} ",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize:
                          Theme.of(context).textTheme.titleLarge!.fontSize),
                ),
              ]),
              Expanded(
                child: LinearPercentIndicator(
                  percent: WeatherDayTime.dayConsumedPercentage(_weather),
                  lineHeight: 10,
                  barRadius: const Radius.circular(10),
                ),
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(Icons.nightlight_round, color: Colors.grey),
                    Text(
                      "${_weather.sysSunrise} ",
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize:
                              Theme.of(context).textTheme.titleLarge!.fontSize),
                    ),
                  ]),
            ],
          ),
          const Divider(),
          Text(
            "Remaining DayLight ${WeatherDayTime.getRemainingDayTime(_weather)} hours",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize),
          ),
        ],
      ),
    ));
  }
}

class HumidityWidget extends StatelessWidget {
  const HumidityWidget({
    super.key,
    required Weather? weather,
  }) : _weather = weather;

  final Weather? _weather;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text("Humidity ${_weather!.mainHumidity}%",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                  )),
            ],
          ),
        ));
  }
}

class WindConditionsWidget extends StatelessWidget {
  const WindConditionsWidget({
    super.key,
    required Weather? weather,
  }) : _weather = weather;

  final Weather? _weather;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text("Wind Conditions",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize:
                          Theme.of(context).textTheme.headlineSmall!.fontSize)),
              Divider(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text("Wind Speed",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .fontSize)),
                          Text("${_weather!.windSpeed} m/sec",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .fontSize)),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text("Wind Direction",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .fontSize)),
                          Text(
                              "Towards ${WindDirectionConvertor.convert(_weather.windDegree)}",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .fontSize)),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}

class TemperatureDetailsWidget extends StatelessWidget {
  const TemperatureDetailsWidget({
    super.key,
    required Weather? weather,
  }) : _weather = weather;

  final Weather? _weather;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          Text("Temperatures",
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
                  color: Theme.of(context).colorScheme.onPrimaryContainer)),
          Divider(color: Theme.of(context).colorScheme.onPrimaryContainer),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.thermostat_rounded,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
              const SizedBox(
                width: 10,
              ),
              Text("Current ${(_weather!.mainTemp - 273.15).round()}°C",
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleMedium!.fontSize,
                      color: Theme.of(context).colorScheme.onPrimaryContainer)),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.thermostat_rounded,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
              const SizedBox(
                width: 10,
              ),
              Text("Todays Min. ${(_weather.mainTempMin - 273.15).round()}°C",
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleMedium!.fontSize,
                      color: Theme.of(context).colorScheme.onPrimaryContainer)),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.thermostat_rounded,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
              const SizedBox(
                width: 10,
              ),
              Text("Todays max. ${(_weather.mainTempMax - 273.15).round()}°C",
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleMedium!.fontSize,
                      color: Theme.of(context).colorScheme.onPrimaryContainer)),
            ],
          ),
        ]),
      ),
    );
  }
}

class MainTemperatureWidget extends StatelessWidget {
  const MainTemperatureWidget({
    super.key,
    required Weather? weather,
  }) : _weather = weather;

  final Weather? _weather;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Feels Like",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.network(
                  "https://openweathermap.org/img/wn/${_weather!.weatherIcon}@2x.png",
                  fit: BoxFit.contain,
                ),
                Text(
                  "${(_weather.mainFeelsLike - 273.15).round()} °C",
                  style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.displayLarge!.fontSize,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            Divider(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            Text(_weather.weatherDescription,
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                    color: Theme.of(context).colorScheme.onPrimaryContainer))
          ],
        ),
      ),
    );
  }
}

class CityCountryTagWidget extends StatelessWidget {
  const CityCountryTagWidget({
    super.key,
    required Weather? weather,
  }) : _weather = weather;

  final Weather? _weather;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_on_rounded,
              color: Theme.of(context).colorScheme.onSurface),
          Text("${_weather!.cityName}, ${_weather.sysCountry}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
              ))
        ],
      ),
    );
  }
}
