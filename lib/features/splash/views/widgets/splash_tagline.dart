import 'package:flutter/material.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';

/// Splash Tagline - Subtitle text with fade animation
///
/// Features:
/// - "Building Your Digital Heritage" text
/// - Fade in animation
/// - Smooth entrance effect
class SplashTagline extends StatefulWidget {
  const SplashTagline({super.key});

  @override
  State<SplashTagline> createState() => _SplashTaglineState();
}

class _SplashTaglineState extends State<SplashTagline>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

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

  /// Initialize fade in and slide up animation
  void _initializeAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), // Match splash duration
    );

    // Fade in animation starting from 55% and ending at 90% of splash animation
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 0.90, curve: Curves.easeIn),
      ),
    );

    // Slide up animation
    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 0.5), // Start slightly below
          end: Offset.zero, // End at normal position
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.55, 0.90, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: Opacity(opacity: _opacityAnimation.value, child: child),
        );
      },
      child: Text(
        'Building Your Digital Heritage',
        style: getSubHeadingStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
