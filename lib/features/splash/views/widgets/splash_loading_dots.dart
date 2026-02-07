import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Splash Loading Dots - Animated loading indicator
///
/// Features:
/// - Three animated white dots
/// - Wave/pulse animation pattern
/// - Smooth bounce effect
/// - Loading state indicator
class SplashLoadingDots extends StatefulWidget {
  const SplashLoadingDots({super.key});

  @override
  State<SplashLoadingDots> createState() => _SplashLoadingDotsState();
}

class _SplashLoadingDotsState extends State<SplashLoadingDots>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<Animation<double>> _dotAnimations = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Initialize wave animation for dots
  void _initializeAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(); // Loop animation

    // Create staggered animations for 3 dots
    for (int i = 0; i < 3; i++) {
      final double delay = i * 0.15; // Stagger each dot: 0, 0.15, 0.30
      final double intervalStart = delay;
      final double intervalEnd = (delay + 0.55).clamp(
        0.0,
        1.0,
      ); // Ensure within bounds

      _dotAnimations.add(
        TweenSequence<double>([
          // Bounce down
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 0.0,
              end: 12.h,
            ).chain(CurveTween(curve: Curves.easeInCubic)),
            weight: 40,
          ),
          // Bounce up
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 12.h,
              end: 0.0,
            ).chain(CurveTween(curve: Curves.easeOutCubic)),
            weight: 40,
          ),
          // Pause
          TweenSequenceItem(
            tween: Tween<double>(begin: 0.0, end: 0.0),
            weight: 20,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(intervalStart, intervalEnd, curve: Curves.linear),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.h,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return _buildAnimatedDot(index);
        }),
      ),
    );
  }

  /// Build individual animated dot
  Widget _buildAnimatedDot(int index) {
    return AnimatedBuilder(
      animation: _dotAnimations[index],
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _dotAnimations[index].value),
          child: child,
        );
      },
      child: Container(
        width: 8.w,
        height: 8.h,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      ),
    );
  }
}
