import 'package:get/get.dart';
import '../models/health_data_model.dart';
import '../services/health_service.dart';

class HealthController extends GetxController {
  final HealthService _healthService = HealthService();

  final RxList<HealthData> healthData = <HealthData>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHealthData();
  }

  Future<void> fetchHealthData() async {
    isLoading.value = true;
    try {
      final data = await _healthService.fetchLast7DaysSteps();
      healthData.value = data;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load health data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    await fetchHealthData();
  }
}
