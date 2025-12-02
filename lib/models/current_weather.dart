class CurrentWeather {
  final String cityName;
  final double temperature;
  final String condition;
  final String iconUrl;

  CurrentWeather({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.iconUrl,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      cityName: json["location"]["name"],
      temperature: json["current"]["temp_c"].toDouble(),
      condition: json["current"]["condition"]["text"],
      iconUrl: "https:${json["current"]["condition"]["icon"]}",
    );
  }
}
