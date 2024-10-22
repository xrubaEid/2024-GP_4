class Sensor {
  String sensorId;
  double temperature;
  double spO2;
  double heartRate;

  Sensor({
    required this.sensorId,
    required this.temperature,
    required this.spO2,
    required this.heartRate,
  });

  factory Sensor.fromMap(Map<dynamic, dynamic> data) {
    return Sensor(
      sensorId: data['sensorId'] ?? '',
      temperature: (data['Temperatura'] ?? 0).toDouble(),
      spO2: (data['SpO2'] ?? 0).toDouble(),
      heartRate: (data['HeartRate'] ?? 0).toDouble(),
    );
  }
}
