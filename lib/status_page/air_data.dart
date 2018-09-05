class AirData {
  double gasNormalized, gasQuality, humidityNormalized, humidityQuality;
  double overallQuality;
  int temperature;
  String overallQualityString;
  String gasQualityString;

  AirData(
      {this.gasNormalized,
      this.gasQuality,
      this.humidityNormalized,
      this.humidityQuality,
      this.gasQualityString,
      this.overallQuality,
      this.overallQualityString,
      this.temperature});

  factory AirData.zero() {
    return AirData(
      gasNormalized: 0.0,
      gasQuality: 0.0,
      humidityNormalized: 0.0,
      gasQualityString: "No data",
      humidityQuality: 0.0,
      overallQuality: 0.0,
      overallQualityString: "No data",
      temperature: 0,
    );
  }
  factory AirData.fromMap(Map map) {
    return AirData(
      gasNormalized: map['gasNormalized'],
      gasQuality: map['gasQuality'],
      humidityNormalized: map['humidityNormalized'],
      humidityQuality: map['humidityQuailty'],
      gasQualityString: map['gasQualityString'],
      overallQuality: map['overallQuality'],
      overallQualityString: map['overallQualityString'],
      temperature: map['temperature'],
    );
  }
}
