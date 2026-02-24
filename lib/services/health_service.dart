import 'package:flutter/foundation.dart';
import 'dart:math';
import '../models/health_data_model.dart';

class HealthService {
  static final HealthService _instance = HealthService._internal();
  factory HealthService() => _instance;
  HealthService._internal();

  Future<List<HealthData>> fetchLast7DaysSteps() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final now = DateTime.now();
      final List<HealthData> healthDataList = [];
      final random = Random();

      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));

        final isWeekend =
            date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday;

        final baseSteps = isWeekend ? 6000 : 9000;
        final variance = isWeekend ? 3000 : 4000;
        final steps = baseSteps + random.nextInt(variance);

        healthDataList.add(HealthData(day: _getDayName(i), steps: steps));
      }

      debugPrint(
        'Generated mock health data: ${healthDataList.map((d) => '${d.day}: ${d.steps}').join(', ')}',
      );
      return healthDataList;
    } catch (e) {
      debugPrint('Error generating health data: $e');
      return _getDefaultMockData();
    }
  }

  List<HealthData> _getDefaultMockData() {
    return [
      HealthData(day: 'Mon', steps: 8500),
      HealthData(day: 'Tue', steps: 10200),
      HealthData(day: 'Wed', steps: 7800),
      HealthData(day: 'Thu', steps: 12000),
      HealthData(day: 'Fri', steps: 9500),
      HealthData(day: 'Sat', steps: 11000),
      HealthData(day: 'Sun', steps: 6500),
    ];
  }

  String _getDayName(int daysAgo) {
    final now = DateTime.now();
    final date = now.subtract(Duration(days: daysAgo));

    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  Future<int> getTodaySteps() async {
    final data = await fetchLast7DaysSteps();
    return data.isNotEmpty ? data.last.steps : 0;
  }

  Future<void> refreshData() async {
    await Future.delayed(const Duration(milliseconds: 300));
    debugPrint('Health data refreshed');
  }
}
