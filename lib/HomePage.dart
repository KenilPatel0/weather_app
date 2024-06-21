// HomePage
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wether_app/Weather_Service.dart';
import 'package:wether_app/Wether_Model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Api Key
  final _weatherService = WeatherService('824183303dfc25daaa7a6f72a490f26a');

  Weather? _weather;
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  // Fetch weather
// Fetch weather
  _fetchWeather(String locationName) async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (locationName.isEmpty) {
        _showErrorDialog('Location name cannot be empty.');
        return;
      }

      final weather = await _weatherService.getWeather(locationName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      _showErrorDialog('Location not recognized!');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[300],
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Color getWeatherColor(String? mainCondition) {
    switch (mainCondition?.toLowerCase()) {
      case 'clouds':
        return Colors.grey[700] ?? Colors.grey;
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return Colors.blueGrey.shade400;
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return Colors.blue.shade600;
      case 'thunderstorm':
        return Colors.deepPurple.shade700;
      case 'clear':
        return Colors.orange.shade300;
      default:
        return Colors.blueGrey.shade400;
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    switch (mainCondition?.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/Weather_Animations/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/Weather_Animations/rain_shower.json';
      case 'thunderstorm':
        return 'assets/Weather_Animations/thunder.json';
      case 'clear':
        return 'assets/Weather_Animations/sunny.json';
      default:
        return 'assets/Weather_Animations/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _weatherService.getCurrentLocation().then((cityName) {
      _fetchWeather(cityName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: getWeatherColor(_weather?.mainCondition),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Weather',
                  style: TextStyle(fontSize: 50, color: Colors.white),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _controller,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.white)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.white)),
                      hintText: 'Enter city...',
                      hintStyle: TextStyle(color: Colors.white),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _fetchWeather(_controller.text);
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onSubmitted: (value) {
                      _fetchWeather(value);
                    },
                  ),
                ),
                if (_isLoading)
                  CircularProgressIndicator(
                    color: Colors.white,
                  )
                else if (_weather != null) ...[
                  SizedBox(height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 35,
                      ),
                      Text(
                        _weather?.cityName ?? '',
                        style: TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
                  SizedBox(height: 10),
                  Text(
                    '${_weather?.temperature.round()}°C',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  Text(
                    _weather?.mainCondition ?? "",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
