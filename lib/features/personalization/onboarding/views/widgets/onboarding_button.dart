import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/core/localization/app_string_localizations.dart';
import 'package:legacyhub/core/utils/constants/svg_path.dart';
import 'package:legacyhub/core/utils/helpers/app_helpers.dart';
import 'package:legacyhub/core/utils/helpers/svg_icon_helper.dart';

/// ============================================================================
/// ONBOARDING BUTTON
/// ============================================================================
/// Animated bottom button matching Figma design.
///
/// Features:
/// - White rounded rectangle with shadow
/// - "Next" text with arrow icon (screens 1-3)
/// - "Get Started" text with arrow icon (screen 4)
/// - Entrance animation (fade + slide up)
/// - Press animation (scale down)
/// - Premium business feel
/// ============================================================================

class OnboardingButton extends StatefulWidget {
  final bool isLastPage;
  final VoidCallback onPressed;

  const OnboardingButton({
    super.key,
    required this.isLastPage,
    required this.onPressed,
  });

  @override
  State<OnboardingButton> createState() => _OnboardingButtonState();
}

class _OnboardingButtonState extends State<OnboardingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  double _pressScale = 1.0;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelpers.isDarkMode;
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressScale = 0.96),
          onTapUp: (_) {
            setState(() => _pressScale = 1.0);
            widget.onPressed();
          },
          onTapCancel: () => setState(() => _pressScale = 1.0),
          child: AnimatedScale(
            scale: _pressScale,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeInOut,
            child: Container(
              width: double.infinity,
              height: 65.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.25)
                        : Colors.black.withValues(alpha: 0.25),
                    blurRadius: 50,
                    offset: const Offset(0, 25),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Button text with AnimatedSwitcher
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: Text(
                      widget.isLastPage
                          ? AppStrings.getStarted.toUpperCase()
                          : AppStrings.next.toUpperCase(),
                      key: ValueKey(widget.isLastPage),
                      style: getBoldTextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),

                  SizedBox(width: 6.w),

                  // Arrow icon
                  widget.isLastPage
                      ? SizedBox.shrink()
                      : SvgIconHelper.buildIcon(
                          assetPath: SvgPath.arrowLineRight,
                          color: isDark ? Colors.white : Colors.black,
                          size: 28.sp,
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
