import 'package:flutter/material.dart';
import 'weather_api_service.dart';
import 'weather.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();
  Future<Weather?>? _weatherData;

  Future<Weather?> _fetchWeather(String city) async {
    try {
      final apiService = WeatherApiService();
      final jsonResponse = await apiService.fetchWeather(city);
      return Weather.fromJson(jsonResponse);
    } catch (e) {
      print("Erro: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Clima App")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: "Digite o nome da cidade",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_cityController.text.isNotEmpty) {
                  setState(() {
                    _weatherData = _fetchWeather(_cityController.text);
                  });
                }
              },
              child: const Text("Buscar Clima"),
            ),
            const SizedBox(height: 16),
            _weatherData != null
                ? FutureBuilder<Weather?>(
                    future: _weatherData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text("Erro: ${snapshot.error}");
                      } else if (snapshot.hasData && snapshot.data != null) {
                        final weather = snapshot.data!;
                        return Column(
                          children: [
                            Text(
                              "Cidade: ${weather.cityName}",
                              style: const TextStyle(fontSize: 20),
                            ),
                            Text(
                              "Temperatura: ${weather.temperature.toStringAsFixed(2)}°C",
                              style: const TextStyle(fontSize: 20),
                            ),
                            Text(
                              "Descrição: ${weather.description}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        );
                      } else {
                        return const Text("Nenhum dado disponível.");
                      }
                    },
                  )
                : const Text("Digite o nome de uma cidade para buscar."),
          ],
        ),
      ),
    );
  }
}
