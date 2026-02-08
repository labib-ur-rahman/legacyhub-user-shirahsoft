import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

/// ============================================================================
/// ONBOARDING LOTTIE WIDGET
/// ============================================================================
/// Cached Lottie animation widget with glow effect.
/// - Prevents unnecessary Lottie reloads using AutomaticKeepAliveClientMixin
/// - Rounded container with glow shadow matching Figma design
/// - Smooth scale entrance animation
/// ============================================================================

class OnboardingLottie extends StatefulWidget {
  final String lottieAsset;
  final Color glowColor;

  const OnboardingLottie({
    super.key,
    required this.lottieAsset,
    required this.glowColor,
    required this.pageIndex,
  });

  final int pageIndex;

  @override
  State<OnboardingLottie> createState() => _OnboardingLottieState();
}

class _OnboardingLottieState extends State<OnboardingLottie>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: SizedBox(
        height: widget.pageIndex == 3 ? 100.h : 200.h,
        child: Lottie.asset(
          widget.lottieAsset,
          fit: BoxFit.contain,
          repeat: true,
          animate: true,
        ),
      ),
    );
  }
}
