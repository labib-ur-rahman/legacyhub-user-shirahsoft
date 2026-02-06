import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:legacyhub/core/utils/constants/colors.dart';
import 'package:legacyhub/core/utils/constants/enums.dart';

/// Custom Button - Reusable button widget with consistent styling
/// Supports primary, secondary, and text button styles
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final IconData? icon;
  final double? fontSize;
  final FontWeight? fontWeight;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.icon,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = !isEnabled || onPressed == null;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 48.h,
      child: _buildButton(context, isDisabled),
    );
  }

  Widget _buildButton(BuildContext context, bool isDisabled) {
    switch (type) {
      /// -- Primary Button
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: isDisabled ? null : (isLoading ? null : onPressed),
          style: ElevatedButton.styleFrom(
            backgroundColor: isDisabled
                ? AppColors.buttonDisabled
                : AppColors.buttonPrimary,
            foregroundColor: isDisabled ? AppColors.darkGrey : AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(12.r),
            ),
            side: BorderSide(
              color: isDisabled
                  ? AppColors.buttonDisabled
                  : AppColors.buttonPrimary,
            ),
            padding:
                padding ??
                EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          ),
          child: _buildButtonContent(),
        );

      /// -- Secondary Button
      case ButtonType.secondary:
        return OutlinedButton(
          onPressed: isDisabled ? null : (isLoading ? null : onPressed),
          style: OutlinedButton.styleFrom(
            foregroundColor: isDisabled
                ? AppColors.darkGrey
                : AppColors.buttonPrimary,
            side: BorderSide(
              color: isDisabled
                  ? AppColors.buttonDisabled
                  : AppColors.buttonPrimary,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(12.r),
            ),
            padding:
                padding ??
                EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          ),
          child: _buildButtonContent(),
        );

      /// -- Text Button
      case ButtonType.text:
        return TextButton(
          onPressed: isDisabled ? null : (isLoading ? null : onPressed),
          style: TextButton.styleFrom(
            foregroundColor: isDisabled
                ? AppColors.buttonDisabled
                : AppColors.buttonPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(12.r),
            ),
            padding:
                padding ??
                EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          ),
          child: _buildButtonContent(),
        );
    }
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        width: 20.w,
        height: 20.h,
        child: const CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18.sp),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize ?? 16.sp,
              fontWeight: fontWeight ?? FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize ?? 16.sp,
        fontWeight: fontWeight ?? FontWeight.w600,
      ),
    );
  }
}
