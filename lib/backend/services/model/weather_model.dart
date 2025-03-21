class WeatherModel {
  final String city;
  final double temperature;
  final String weather;
  final int humidity;
  final double windSpeed;

  WeatherModel({
    required this.city,
    required this.temperature,
    required this.weather,
    required this.humidity,
    required this.windSpeed,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json["city"],
      temperature: json["temperature"].toDouble(),
      weather: json["weather"],
      humidity: json["humidity"],
      windSpeed: json["wind_speed"].toDouble(),
    );
  }
}
