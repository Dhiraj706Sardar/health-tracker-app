class HealthData {
  final String day;
  final int steps;

  HealthData({
    required this.day,
    required this.steps,
  });

  factory HealthData.fromJson(Map<String, dynamic> json) {
    return HealthData(
      day: json['day'],
      steps: json['steps'],
    );
  }
}
