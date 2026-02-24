import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../utils/app_colors.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.loginGradient(context),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Obx(
                () => authController.isLoading.value
                    ? const CircularProgressIndicator(color: AppColors.textWhite)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildAnimatedIcon(),
                          const SizedBox(height: 24),
                          _buildAnimatedTitle(),
                          const SizedBox(height: 8),
                          _buildAnimatedSubtitle(),
                          const SizedBox(height: 48),
                          _buildAnimatedButton(authController),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(scale: value, child: child),
        );
      },
      child: const Icon(
        Icons.health_and_safety_outlined,
        size: 100,
        color: AppColors.textWhite,
      ),
    );
  }

  Widget _buildAnimatedTitle() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: const Text(
        'Daily Health Tracker',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textWhite,
        ),
      ),
    );
  }

  Widget _buildAnimatedSubtitle() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOut,
      builder: (context, double value, child) => Opacity(
        opacity: value,
        child: child,
      ),
      child: const Text(
        'Track your health journey',
        style: TextStyle(fontSize: 16, color: AppColors.textWhite70),
      ),
    );
  }

  Widget _buildAnimatedButton(AuthController controller) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1400),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(scale: 0.8 + (0.2 * value), child: child),
        );
      },
      child: ElevatedButton.icon(
        onPressed: controller.signInWithGoogle,
        icon: const Icon(Icons.login),
        label: const Text('Sign in with Google'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
