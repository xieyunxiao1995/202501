/// Weather service for mock weather data
class WeatherService {
  // Singleton
  static final WeatherService _instance = WeatherService._internal();
  factory WeatherService() => _instance;
  WeatherService._internal();

  /// Get weather data (mock)
  Future<WeatherData> getWeather(String location) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    return const WeatherData(
      temperature: 22.0,
      condition: WeatherCondition.sunny,
      humidity: 65,
      windSpeed: 12.5,
    );
  }

  /// Get weather icon
  String getWeatherIcon(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.sunny:
        return '☀️';
      case WeatherCondition.cloudy:
        return '☁️';
      case WeatherCondition.rainy:
        return '🌧️';
      case WeatherCondition.snowy:
        return '❄️';
    }
  }

  /// Get status message based on weather
  String getStatusMessage(WeatherData weather) {
    if (weather.temperature > 30) {
      return 'Very hot - bring extra water';
    } else if (weather.temperature < 5) {
      return 'Cold - check sleeping bag rating';
    } else if (weather.condition == WeatherCondition.rainy) {
      return 'Rain expected - pack waterproof gear';
    }
    return 'Good to go';
  }
}

/// Weather data model
class WeatherData {
  final double temperature;
  final WeatherCondition condition;
  final int humidity;
  final double windSpeed;

  const WeatherData({
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
  });
}

/// Weather condition enum
enum WeatherCondition { sunny, cloudy, rainy, snowy }
