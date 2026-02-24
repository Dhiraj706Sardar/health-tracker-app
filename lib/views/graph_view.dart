import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/health_controller.dart';
import '../utils/ui_helpers.dart';
import '../utils/app_colors.dart';

class GraphView extends StatelessWidget {
  const GraphView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HealthController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text('Health Graph'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UIHelpers.fadeInAnimation(
                child: const Text(
                  '7-Day Step Count',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              UIHelpers.scaleAnimation(
                duration: const Duration(milliseconds: 800),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      height: 300,
                      child: _buildBarChart(controller),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              UIHelpers.scaleAnimation(
                duration: const Duration(milliseconds: 1000),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Statistics',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildStatRow(
                          'Average Steps',
                          _calculateAverage(controller).toStringAsFixed(0),
                          Icons.trending_up,
                          0,
                        ),
                        const Divider(),
                        _buildStatRow(
                          'Highest',
                          _findMax(controller).toStringAsFixed(0),
                          Icons.arrow_upward,
                          1,
                        ),
                        const Divider(),
                        _buildStatRow(
                          'Lowest',
                          _findMin(controller).toStringAsFixed(0),
                          Icons.arrow_downward,
                          2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBarChart(HealthController controller) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 15000,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 &&
                    value.toInt() < controller.healthData.length) {
                  return Text(
                    controller.healthData[value.toInt()].day,
                    style: const TextStyle(fontSize: 12),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(
                '${(value / 1000).toStringAsFixed(0)}k',
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: false),
        barGroups: controller.healthData.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.steps.toDouble(),
                color: AppColors.chartBlue,
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  double _calculateAverage(HealthController controller) {
    return controller.healthData.fold<double>(
          0,
          (sum, item) => sum + item.steps,
        ) /
        controller.healthData.length;
  }

  int _findMax(HealthController controller) {
    return controller.healthData
        .map((e) => e.steps)
        .reduce((a, b) => a > b ? a : b);
  }

  int _findMin(HealthController controller) {
    return controller.healthData
        .map((e) => e.steps)
        .reduce((a, b) => a < b ? a : b);
  }

  Widget _buildStatRow(String label, String value, IconData icon, int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 1200 + (index * 100)),
      curve: Curves.easeOut,
      builder: (context, double animValue, child) {
        return Opacity(
          opacity: animValue,
          child: Transform.translate(
            offset: Offset(30 * (1 - animValue), 0),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: AppColors.chartBlue),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
