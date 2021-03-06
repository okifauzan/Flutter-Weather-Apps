import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:weather_apps/models/weather_data.dart';
import 'package:weather_apps/models/forecast_data.dart';
import 'package:weather_apps/widgets/weather.dart';
import 'package:weather_apps/widgets/weather_item.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  WeatherData weatherData;
  ForecastData forecastData;

  loadWeather() async{
    setState(() {
      isLoading = true;
    });
    Position position;
    try{
      position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    } catch (e) {
      print(e);
    }

    if (position != null) {
      final lat = position.latitude;
      final lon = position.longitude;

      final weatherResponse = await http.get('https://api.openweathermap.org/data/2.5/weather?APPID=82ba7e10df2065d55731721ee5d41292&lat=${lat.toString()}&lon=${lon.toString()}');
      final forecastResponse = await http.get('https://api.openweathermap.org/data/2.5/forecast?APPID=82ba7e10df2065d55731721ee5d41292&lat=${lat.toString()}&lon=${lon.toString()}');

      if (weatherResponse.statusCode == 200 &&
          forecastResponse.statusCode == 200) {
        return setState((){
          weatherData = new WeatherData.fromJson(jsonDecode(weatherResponse.body));
          forecastData = new ForecastData.fromJson(jsonDecode(forecastResponse.body));
          isLoading = false;
        });
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState(){
    super.initState();
    loadWeather();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Current Location Weather'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: weatherData != null 
                      ? Weather(weather: weatherData) 
                      : Container(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: isLoading
                      ? CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: new AlwaysStoppedAnimation(Colors.white),
                      )
                      : IconButton(
                        icon: Icon(Icons.refresh),
                        tooltip: 'Refresh',
                        onPressed: loadWeather,
                        color: Colors.blue,
                      ),
                  ),
                ],
              )
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  height: 200.0,
                  child: forecastData != null
                    ? ListView.builder(
                        itemCount: forecastData.list.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => WeatherItem(weather: forecastData.list.elementAt(index)))
                    : Container(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}