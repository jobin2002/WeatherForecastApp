import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/Model/Weatherdata.dart';
import 'package:weatherapp/Services/service_http.dart';

class HomeScrn extends StatefulWidget {
  const HomeScrn({super.key});

  @override
  State<HomeScrn> createState() => _HomeScrnState();
}

class _HomeScrnState extends State<HomeScrn> {
  late WeatherData weatherinfo;
  late TextEditingController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = Weatherservice().controller;
    weatherinfo = WeatherData(
      name: "Search Your City",
      temperature: Temperature(current: 0.0),
      humidity: 0,
      maxTemperature: 0,
      wind: Wind(speed: 0.0),
      weather: [],
      pressure: 0,
      seaLevel: 0,
      minTemperature: 0,
    );
    loadSavedWeather();
  }

  Future<void> loadSavedWeather() async {
    final savedWeather = await Weatherservice().getSavedWeatherData();
    if (savedWeather != null) {
      setState(() {
        weatherinfo = savedWeather;
        _isLoading = false;
      });
    } else {
      myWeather();
    }
  }

  myWeather() {
    setState(() {
      _isLoading = true;
    });
    Weatherservice().fetchWeather(_controller.text).then((value) {
      setState(() {
        weatherinfo = value;
        _isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('EEEE d,MMMM yyyy').format(DateTime.now());
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
              child: Text("Weather Forecast",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2))),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18.0)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: TextField(
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
                        controller: _controller,
                        decoration: InputDecoration(
                            label: const Text("Enter City",
                                style: TextStyle(fontSize: 15)),
                            contentPadding: const EdgeInsets.all(2.0),
                            enabledBorder: InputBorder.none,
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.location_on,
                                color: Colors.black),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  Future.delayed(
                                    const Duration(seconds: 3),
                                    () {
                                      _controller.clear();
                                    },
                                  );
                                  myWeather();
                                },
                                icon: const Icon(
                                  Icons.search,
                                  color: Colors.black,
                                )),
                            labelStyle: const TextStyle(color: Colors.black)),
                        onSubmitted: (value) {
                          myWeather();
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : WeatherDetails(
                        weather: weatherinfo,
                        formattedDate: formattedDate,
                        formattedTime: formattedTime,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherDetails extends StatelessWidget {
  final WeatherData weather;
  final String formattedDate;
  final String formattedTime;

  const WeatherDetails({
    Key? key,
    required this.weather,
    required this.formattedDate,
    required this.formattedTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              weather.name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 80),
            Align(
                alignment: Alignment.center,
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      image: DecorationImage(
                          image: AssetImage("assets/images/Cloud.jpg"),
                          fit: BoxFit.cover)),
                )),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${weather.temperature.current.toStringAsFixed(2)}°C",
                    style: const TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                      weather.weather.isNotEmpty ? weather.weather[0].main : '',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(formattedDate,
              style: const TextStyle(color: Colors.white, fontSize: 18)),
        ),
        Text(formattedTime,
            style: const TextStyle(color: Colors.white, fontSize: 18)),
        const SizedBox(
          height: 50,
        ),
        Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.wind_power),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text("${weather.wind.speed} km/h"),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text("Wind"),
                            )
                          ]),
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.sunny),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                  "${weather.maxTemperature.toStringAsFixed(2)}°C"),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text("Max"),
                            )
                          ]),
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.sunny),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                  "${weather.minTemperature.toStringAsFixed(2)}°C"),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text("Min"),
                            ),
                          ]),
                    ),
                  ],
                )),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.water_drop),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("${weather.humidity}%"),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text("Humidity"),
                          ),
                        ]),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.air),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("${weather.pressure}hPa"),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text("Pressure"),
                          ),
                        ]),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.leaderboard),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("${weather.seaLevel}m"),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text("Sea-Level"),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
