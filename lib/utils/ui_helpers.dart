import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class UIHelpers {
  UIHelpers._();

  static Widget fadeInAnimation({
    required Widget child,
    int delay = 0,
    Duration? duration,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration ?? Duration(milliseconds: 600 + delay),
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
      child: child,
    );
  }

  static Widget scaleAnimation({
    required Widget child,
    int delay = 0,
    Duration? duration,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration ?? Duration(milliseconds: 600 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: 0.9 + (0.1 * value),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  static BoxDecoration gradientCard(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      gradient: LinearGradient(
        colors: isDark
            ? [AppColors.cardGradientDark1, AppColors.cardGradientDark2]
            : [AppColors.cardGradientLight1, AppColors.cardGradientLight2],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
      border: isDark ? null : Border.all(color: AppColors.borderLight, width: 1),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withValues(alpha: 0.3)
              : (color ?? AppColors.primary).withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
