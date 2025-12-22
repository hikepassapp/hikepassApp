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
    final weatherMain = json['weather'][0]['main'] as String;
    
    return WeatherModel(
      temperature: (json['main']['temp'] as num).toDouble() - 273.15,
      weatherCondition: _translateWeatherCondition(weatherMain),
      weatherDescription: json['weather'][0]['description'] as String,
      weatherIcon: json['weather'][0]['icon'] as String,
      location: json['name'] as String,
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
    );
  }

  // Translate weather condition ke Bahasa Indonesia
  static String _translateWeatherCondition(String condition) {
    final translations = {
      'Clear': 'Cerah',
      'Clouds': 'Berawan',
      'Rain': 'Hujan',
      'Drizzle': 'Gerimis',
      'Thunderstorm': 'Petir',
      'Snow': 'Salju',
      'Mist': 'Berkabut',
      'Smoke': 'Berasap',
      'Haze': 'Kabut Asap',
      'Dust': 'Berdebu',
      'Fog': 'Berkabut',
      'Sand': 'Berpasir',
      'Ash': 'Abu Vulkanik',
      'Squall': 'Angin Kencang',
      'Tornado': 'Tornado',
    };
    
    return translations[condition] ?? condition;
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