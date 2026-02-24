import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/timer_controller.dart';
import '../utils/ui_helpers.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TimerController());

    return UIHelpers.scaleAnimation(
      duration: const Duration(milliseconds: 800),
      child: Container(
        decoration: UIHelpers.gradientCard(context),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Next Activity Reminder',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Obx(
              () => Text(
                controller.formattedTime,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: controller.isRunning.value
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => ElevatedButton.icon(
                    onPressed: controller.isRunning.value
                        ? controller.pauseTimer
                        : controller.startTimer,
                    icon: Icon(
                      controller.isRunning.value
                          ? Icons.pause
                          : Icons.play_arrow,
                      size: 20,
                    ),
                    label: Text(controller.isRunning.value ? 'Pause' : 'Start'),
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: controller.resetTimer,
                  icon: const Icon(Icons.refresh, size: 20),
                  label: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
