// app/data/repositories/weather_repository.dart

import 'package:get/get.dart';
import 'weather_model.dart';
import 'weather_provider.dart';

class WeatherRepository {
  final WeatherProvider _provider = Get.find<WeatherProvider>();

  Future<WeatherModel> getWeatherByCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _provider.getWeatherByCoordinates(
        latitude: latitude,
        longitude: longitude,
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.body);
      } else {
        throw Exception(
          'Failed to load weather: ${response.statusText}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<WeatherModel> getWeatherByCity(String cityName) async {
    try {
      final response = await _provider.getWeatherByCity(cityName);

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.body);
      } else {
        throw Exception(
          'Failed to load weather: ${response.statusText}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}