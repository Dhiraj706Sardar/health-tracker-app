import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/activity_log_model.dart';
import '../services/api_service.dart';

class ActivityController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxList<ActivityLog> activityLogs = <ActivityLog>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxInt currentPage = 1.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchActivityLogs();
  }

  Future<void> fetchActivityLogs() async {
    if (isLoading.value || !hasMore.value) return;

    if (currentPage.value == 1) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    errorMessage.value = '';

    try {
      final logs = await _apiService.fetchActivityLogs(currentPage.value);

      if (logs.isEmpty) {
        hasMore.value = false;
      } else {
        activityLogs.addAll(logs);
        currentPage.value++;

        if (logs.length < 10) {
          hasMore.value = false;
        }
      }
    } catch (e) {
      debugPrint('Error fetching activity logs: $e');
      errorMessage.value = 'Failed to load activity logs';

      if (currentPage.value == 1) {
        Get.snackbar(
          'Error',
          'Failed to load activity logs. Please check your internet connection.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  @override
  Future<void> refresh() async {
    activityLogs.clear();
    currentPage.value = 1;
    hasMore.value = true;
    errorMessage.value = '';
    await fetchActivityLogs();
  }
}
