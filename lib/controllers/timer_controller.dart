import 'dart:async';
import 'package:get/get.dart';
import '../services/notification_service.dart';
import '../utils/constants.dart';

class TimerController extends GetxController {
  final RxInt remainingSeconds = AppConstants.timerDuration.obs;
  final RxBool isRunning = false.obs;
  Timer? _timer;
  final NotificationService _notificationService = NotificationService();

  @override
  void onInit() {
    super.onInit();
    _notificationService.initialize();
    startTimer();
  }

  void startTimer() {
    if (isRunning.value) return;

    isRunning.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        _onTimerComplete();
      }
    });
  }

  void pauseTimer() {
    isRunning.value = false;
    _timer?.cancel();
  }

  void resetTimer() {
    _timer?.cancel();
    remainingSeconds.value = AppConstants.timerDuration;
    isRunning.value = false;
  }

  void _onTimerComplete() {
    resetTimer();
    _notificationService.showTimerCompletionNotification();
    
    // Show in-app snackbar as well
    Get.snackbar(
      '⏰ Timer Complete!',
      'Time for your next health activity',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 5),
      backgroundColor: Get.theme.colorScheme.primaryContainer,
      colorText: Get.theme.colorScheme.onPrimaryContainer,
    );
  }

  String get formattedTime {
    int minutes = remainingSeconds.value ~/ 60;
    int seconds = remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
