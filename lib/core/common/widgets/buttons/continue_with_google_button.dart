import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:legacyhub/core/utils/constants/svg_path.dart';

/// Continue with Google button — used on login and signup screens
/// Text is NOT localized per requirement: always "Continue with Google"
class ContinueWithGoogleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const ContinueWithGoogleButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : const Color(0xFFF9FAFB),
          side: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : const Color(0xFFE5E7EB),
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
        child: isLoading
            ? SizedBox(
                width: 24.w,
                height: 24.h,
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(SvgPath.icGoogle, width: 24.w, height: 24.h),
                  SizedBox(width: 12.w),
                  Text(
                    'Continue with Google',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
