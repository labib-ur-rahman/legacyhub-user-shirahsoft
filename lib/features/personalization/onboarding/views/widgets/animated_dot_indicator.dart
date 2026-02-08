import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ============================================================================
/// ANIMATED DOT INDICATOR
/// ============================================================================
/// iOS + Stripe inspired dot indicator with smooth animations.
///
/// Features:
/// - Active dot expands horizontally (pill shape) with AnimatedContainer
/// - Inactive dots are small circles with white 30% opacity
/// - Clickable dots for direct page navigation
/// - Smooth border + shadow on active state
/// - Premium professional feel matching Figma design
/// ============================================================================

class AnimatedDotIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalDots;
  final ValueChanged<int> onDotTapped;

  const AnimatedDotIndicator({
    super.key,
    required this.currentIndex,
    required this.totalDots,
    required this.onDotTapped,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 12.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalDots, (index) {
          final isActive = index == currentIndex;

          return GestureDetector(
            onTap: () => onDotTapped(index),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOutCubic,
                width: isActive ? 48.w : 12.w,
                height: 12.h,
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(100.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 1,
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 25,
                            offset: const Offset(0, 20),
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : [],
                ),
                // Inner fill for active dot
                child: isActive
                    ? Padding(
                        padding: EdgeInsets.all(1.w),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          );
        }),
      ),
    );
  }
}
