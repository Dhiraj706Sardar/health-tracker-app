import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/theme_controller.dart';
import '../widgets/timer_widget.dart';
import '../utils/ui_helpers.dart';
import '../utils/app_colors.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                themeController.isDarkMode
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: themeController.toggleTheme,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: authController.signOut,
          ),
        ],
      ),
      body: Obx(() {
        final user = authController.currentUser.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileCard(context, user),
              const SizedBox(height: 24),
              const TimerWidget(),
              const SizedBox(height: 32),
              Text(
                'Quick Actions',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildMenuCard(
                context,
                'Health Graph',
                'View your 7-day step count',
                Icons.insights_rounded,
                AppColors.menuHealthGraph,
                () => Get.toNamed('/graph'),
              ),
              const SizedBox(height: 16),
              _buildMenuCard(
                context,
                'Activity Logs',
                'Browse your activity history',
                Icons.history_rounded,
                AppColors.menuActivityLogs,
                () => Get.toNamed('/activity-logs'),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileCard(BuildContext context, dynamic user) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return UIHelpers.fadeInAnimation(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? AppColors.profileGradientDark
                : AppColors.profileGradientLight,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.textWhite, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.textWhite,
                backgroundImage:
                    user.photoUrl != null && user.photoUrl!.isNotEmpty
                        ? NetworkImage(user.photoUrl!)
                        : null,
                child: user.photoUrl == null || user.photoUrl!.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 36,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textWhite,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textWhite.withValues(alpha: 0.9),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return UIHelpers.scaleAnimation(
      child: Container(
        decoration: UIHelpers.gradientCard(context, color: color),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color.withValues(alpha: 0.8), color],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(icon, size: 28, color: AppColors.textWhite),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.6),
                              ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
