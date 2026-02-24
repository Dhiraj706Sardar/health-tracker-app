import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/activity_controller.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/empty_state.dart';
import '../utils/app_colors.dart';

class ActivityLogsView extends StatefulWidget {
  const ActivityLogsView({super.key});

  @override
  State<ActivityLogsView> createState() => _ActivityLogsViewState();
}

class _ActivityLogsViewState extends State<ActivityLogsView> {
  late final ActivityController controller;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ActivityController());
    scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      controller.fetchActivityLogs();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text('Activity Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refresh,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.activityLogs.isEmpty && controller.isLoading.value) {
          return const LoadingIndicator(message: 'Loading activity logs...');
        }

        if (controller.activityLogs.isEmpty && !controller.isLoading.value) {
          return EmptyState(
            icon: Icons.error_outline,
            title: 'Failed to load activity logs',
            subtitle: 'Please check your internet connection',
            actionLabel: 'Retry',
            onAction: controller.refresh,
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: controller.activityLogs.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.activityLogs.length) {
                return _buildLoadingFooter();
              }

              final log = controller.activityLogs[index];
              return _buildLogCard(log, index);
            },
          ),
        );
      }),
    );
  }

  Widget _buildLoadingFooter() {
    if (controller.isLoadingMore.value) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (!controller.hasMore.value) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            'No more logs',
            style: TextStyle(color: AppColors.chartGrey),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildLogCard(log, int index) {
    final animationDelay = index < 10 ? index * 50 : 0;

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + animationDelay),
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(30 * (1 - value), 0),
            child: Transform.scale(scale: 0.95 + (0.05 * value), child: child),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.only(bottom: 12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showLogDetail(log),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _buildAvatar(log.id, animationDelay),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _capitalizeTitle(log.title),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            letterSpacing: 0.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _capitalizeFirstLetter(log.body),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios, size: 14),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(int id, int delay) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.elasticOut,
      builder: (context, double value, child) =>
          Transform.scale(scale: value, child: child),
      child: CircleAvatar(
        backgroundColor: AppColors.chartBlue,
        child: Text('$id', style: const TextStyle(color: AppColors.textWhite)),
      ),
    );
  }

  void _showLogDetail(log) {
    Get.dialog(
      TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        builder: (context, double value, child) {
          return Transform.scale(
            scale: 0.8 + (0.2 * value),
            child: Opacity(opacity: value, child: child),
          );
        },
        child: AlertDialog(
          title: Text(_capitalizeTitle(log.title)),
          content: SingleChildScrollView(
            child: Text(
              _capitalizeFirstLetter(log.body),
              style: const TextStyle(height: 1.5),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('Close')),
          ],
        ),
      ),
    );
  }

  String _capitalizeTitle(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
