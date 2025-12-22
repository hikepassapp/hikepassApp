// app/data/models/weather_model.dart

class WeatherModel {
  final double temperature;
  final String weatherCondition;
  final String weatherDescription;
  final String weatherIcon;
  final String location;
  final int humidity;
  final double windSpeed;

  WeatherModel({
    required this.temperature,
    required this.weatherCondition,
    required this.weatherDescription,
    required this.weatherIcon,
    required this.location,
    required this.humidity,
    required this.windSpeed,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: (json['main']['temp'] as num).toDouble() - 273.15,
      weatherCondition: json['weather'][0]['main'] as String,
      weatherDescription: json['weather'][0]['description'] as String,
      weatherIcon: json['weather'][0]['icon'] as String,
      location: json['name'] as String,
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
    );
  }

  String getIconUrl() {
    return 'https://openweathermap.org/img/wn/$weatherIcon@2x.png';
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'weatherCondition': weatherCondition,
      'weatherDescription': weatherDescription,
      'weatherIcon': weatherIcon,
      'location': location,
      'humidity': humidity,
      'windSpeed': windSpeed,
    };
  }
}