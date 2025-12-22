import 'package:get/get.dart';

class WeatherProvider extends GetConnect {
  static const String _apiKey = '3381fdd4ce05562d4af15444f35bfdc4';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  @override
  void onInit() {
    httpClient.baseUrl = _baseUrl;
    httpClient.timeout = const Duration(seconds: 30);
    httpClient.addRequestModifier<dynamic>((request) {
      print('Request: ${request.url}');
      return request;
    });

    httpClient.addResponseModifier((request, response) {
      print('Response: ${response.statusCode}');
      return response;
    });
  }

  Future<Response> getWeatherByCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    return get(
      '/weather',
      query: {
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'appid': _apiKey,
      },
    );
  }

  Future<Response> getWeatherByCity(String cityName) async {
    return get(
      '/weather',
      query: {
        'q': cityName,
        'appid': _apiKey,
      },
    );
  }
}