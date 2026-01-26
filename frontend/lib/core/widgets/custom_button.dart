import 'package:flutter/material.dart';
import '../config/colors.dart';

enum ButtonType { primary, secondary, outline, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 56,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    // Couleurs selon le type
    Color backgroundColor;
    Color foregroundColor;
    BorderSide? border;

    switch (type) {
      case ButtonType.primary:
        backgroundColor = AppColors.evergreen;
        foregroundColor = Colors.white;
        border = null;
        break;
      case ButtonType.secondary:
        backgroundColor = AppColors.sage;
        foregroundColor = Colors.white;
        border = null;
        break;
      case ButtonType.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = AppColors.evergreen;
        border = const BorderSide(color: AppColors.evergreen, width: 2);
        break;
      case ButtonType.text:
        backgroundColor = Colors.transparent;
        foregroundColor = AppColors.evergreen;
        border = null;
        break;
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: type == ButtonType.primary || type == ButtonType.secondary ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: border ?? BorderSide.none,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    type == ButtonType.outline || type == ButtonType.text
                        ? AppColors.evergreen
                        : Colors.white,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: foregroundColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}