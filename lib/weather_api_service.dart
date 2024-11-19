import 'dart:convert';
import 'dart:io';

class WeatherApiService {
  final String _baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  final String _apiKey = "f1534ee0af7dd4486d3b783ff21c479e"; // Substitua pela sua chave.

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final url = Uri.parse("$_baseUrl?q=$city&appid=$_apiKey");

    final request = await HttpClient().getUrl(url);
    final response = await request.close();

    if (response.statusCode == 200) {
      final jsonResponse = await response.transform(utf8.decoder).join();
      return jsonDecode(jsonResponse);
    } else {
      throw Exception("Erro ao buscar os dados de clima.");
    }
  }
}
