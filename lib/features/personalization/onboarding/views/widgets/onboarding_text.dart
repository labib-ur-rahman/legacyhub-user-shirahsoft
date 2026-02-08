import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';

/// ============================================================================
/// ONBOARDING TEXT WIDGET
/// ============================================================================
/// Animated text block for onboarding pages.
/// - Title with Bebas Neue / K2D style (white, bold, tracking)
/// - Subtitle (white 95%, bold)
/// - Description (white 90%, regular) — hidden on last screen
/// - Uses AnimatedSwitcher for smooth text transitions on swipe
/// ============================================================================

class OnboardingText extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? description;
  final int pageIndex;

  const OnboardingText({
    super.key,
    required this.title,
    required this.subtitle,
    this.description,
    required this.pageIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: _slideTransition,
          child: Text(
            title,
            key: ValueKey('title_$pageIndex'),
            style: getK2DTextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: 8.h),

        // Subtitle
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: _slideTransition,
          child: Text(
            subtitle,
            key: ValueKey('subtitle_$pageIndex'),
            style: getBoldTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.95),
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Description (hidden on last screen)
        if (description != null) ...[
          SizedBox(height: 12.h),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: _slideTransition,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                description!,
                key: ValueKey('desc_$pageIndex'),
                style: getSubHeadingStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Slide + Fade transition for AnimatedSwitcher
  Widget _slideTransition(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: child,
      ),
    );
  }
}
