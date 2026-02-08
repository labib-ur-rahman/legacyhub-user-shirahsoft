import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';

/// Splash Text - Animated app name with staggered letter entrance
///
/// Features:
/// - "LegacyHub" text in gradient
/// - Each letter animates individually
/// - Staggered fade + slide effect
/// - Smooth, professional animation
class SplashText extends StatefulWidget {
  const SplashText({super.key});

  @override
  State<SplashText> createState() => _SplashTextState();
}

class _SplashTextState extends State<SplashText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Animation<double>> _letterAnimations = [];
  final List<Animation<Offset>> _slideAnimations = [];

  final String _appName = "LegacyHub";

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Initialize staggered animations for each letter
  void _initializeAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Create staggered animation for each letter
    for (int i = 0; i < _appName.length; i++) {
      // Calculate stagger delay for each letter (reduced to prevent exceeding 1.0)
      final double startTime =
          0.35 + (i * 0.06); // Start at 35%, stagger 6% each
      final double endTime = (startTime + 0.22).clamp(
        0.0,
        1.0,
      ); // Each takes 22%, clamped to 1.0

      // Ensure start < end and both are within bounds
      final double clampedStart = startTime.clamp(0.0, 0.99);
      final double clampedEnd = endTime.clamp(clampedStart + 0.01, 1.0);

      // Opacity animation (fade in)
      _letterAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(clampedStart, clampedEnd, curve: Curves.easeOut),
          ),
        ),
      );

      // Slide animation (slide up)
      _slideAnimations.add(
        Tween<Offset>(
          begin: const Offset(0, 1.5), // Start below
          end: Offset.zero, // End at normal position
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(
              clampedStart,
              clampedEnd,
              curve: Curves.easeOutCubic,
            ),
          ),
        ),
      );
    }

    // Start animation
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(_appName.length, (index) {
          return _buildAnimatedLetter(index);
        }),
      ),
    );
  }

  /// Build individual animated letter
  Widget _buildAnimatedLetter(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimations[index],
          child: Opacity(opacity: _letterAnimations[index].value, child: child),
        );
      },
      child: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Color(0xFFE0F2FF), // Lighter white at bottom
          ],
        ).createShader(bounds),
        child: Text(
          _appName[index],
          style: getK2DTextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
