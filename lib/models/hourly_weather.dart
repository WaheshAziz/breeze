class HourlyWeather {
  final String time;
  final double temp;
  final String condition;
  final String iconUrl;

  HourlyWeather({
    required this.time,
    required this.temp,
    required this.condition,
    required this.iconUrl,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      time: json["time"],
      temp: json["temp_c"].toDouble(),
      condition: json["condition"]["text"],
      iconUrl: "https:${json["condition"]["icon"]}",
    );
  }
}
