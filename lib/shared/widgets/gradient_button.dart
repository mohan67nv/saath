import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Gradient button with loading state
class GradientButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double height;
  final Gradient? gradient;

  const GradientButton({
    super.key,
    required this.child,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height = 56,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: isDisabled 
          ? const LinearGradient(colors: [Color(0xFFD1D5DB), Color(0xFFE5E7EB)])
          : (gradient ?? AppColors.primaryGradient),
        borderRadius: AppRadius.lgRadius,
        boxShadow: isDisabled ? null : AppShadows.glow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: AppRadius.lgRadius,
          child: Center(
            child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : child,
          ),
        ),
      ),
    );
  }
}

/// Outlined button with optional icon
class OutlinedAppButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double height;
  final Color? borderColor;

  const OutlinedAppButton({
    super.key,
    required this.child,
    this.onPressed,
    this.icon,
    this.height = 56,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: borderColor ?? AppColors.border,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.lgRadius,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

/// Icon button with background
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 48,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: AppRadius.mdRadius,
        boxShadow: AppShadows.sm,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppRadius.mdRadius,
          child: Center(
            child: Icon(
              icon,
              color: iconColor ?? AppColors.textPrimary,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

/// Chip/Tag widget
class AppChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;

  const AppChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected 
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.surface,
          borderRadius: AppRadius.fullRadius,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
