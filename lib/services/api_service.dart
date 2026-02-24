import 'dart:convert';
import 'package:daily_health_tracker/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/activity_log_model.dart';
import '../models/health_data_model.dart';

class ApiService {
  static const String baseUrl = AppConstants.apiBaseUrl;

  Future<List<ActivityLog>> fetchActivityLogs(int page) async {
    try {
      final start = (page - 1) * 10;
      final response = await http
          .get(
            Uri.parse('$baseUrl/posts?_start=$start&_limit=10'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));
      debugPrint(response.body.toString());

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        if (data.isEmpty) {
          return [];
        }
        return data.map((json) => ActivityLog.fromJson(json)).toList();
      } else {
        throw Exception('API returned status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching from API: $e');
      throw Exception('Failed to load activity logs: $e');
    }
  }

  Future<List<HealthData>> fetchHealthData() async {
    await Future.delayed(const Duration(milliseconds: 500));

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
}
