//import 'dart:js_interop';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/Weather_forecast.dart';
import 'package:weather_app/secrets.dart';
import 'package:weather_app/weather_additional_info.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityname = 'Bhubaneshwar';

      final res = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityname&APPID=0864b316affca9a3d88d65c4f9724e1d'));
      //print(res.body);
      //print('Hello Inside');
      final data = jsonDecode(res.body);

      if (int.parse(data['cod']) != 200) {
        throw 'An ERROR';
      }

      return data;
      //temp = data['list'][0]['main']['temp'];
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            //backgroundColor: Colors.blue,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  final weather = getCurrentWeather();
                });
                //RefreshProgressIndicator();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          //print(snapshot);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          final data = snapshot.data!;

          final currentWeatherData = data['list'][0];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentWindspeed = currentWeatherData['wind']['speed'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Main card
                //Container for setting width,padding press ctrl+R+shift -> Add  widget
                Container(
                  width: double.infinity, //For allocating Entire width.
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp k',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              ),

                              //Sizebox ->to give space in between
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                              ),
                              Text('$currentSky',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //borderOnForeground: true,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Weather Forecast',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ), //Sizedbox ->gap between two placeholders.
                //Weather forecast card
                const SizedBox(height: 5),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 1; i <= 39; i++)
                //         HourlyForecastItem(
                //           time: data['list'][i]['dt'].toString(),
                //           icons: Icons.cloud,
                //           temp: data['list'][i]['main']['temp'].toString(),
                //         ),
                //     ],
                //   ),
                // ),

                SizedBox(
                  height: 125,
                  child: ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final HourlyForecast = data['list'][index + 1];
                      final time = DateTime.parse(HourlyForecast['dt_txt']);
                      return HourlyForecastItem(
                          time: DateFormat.j().format(time),
                          icons: Icons.cloud,
                          temp: HourlyForecast['main']['temp'].toString());
                    },
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Card(
                        child: AdditionalInfoItem(
                          icon: Icons.water_drop,
                          label: 'Humidity',
                          value: '$currentHumidity',
                        ),
                      ),
                      Card(
                        child: AdditionalInfoItem(
                          icon: Icons.wind_power,
                          label: 'Wind speed',
                          value: '$currentWindspeed',
                        ),
                      ),
                      Card(
                        child: AdditionalInfoItem(
                          icon: Icons.beach_access,
                          label: 'Pressure',
                          value: '$currentPressure',
                        ),
                      ),
                    ]),

                //additional information card

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
