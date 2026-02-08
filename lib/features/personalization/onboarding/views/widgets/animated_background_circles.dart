import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedBackgroundCircles extends StatefulWidget {
  const AnimatedBackgroundCircles({super.key});

  @override
  State<AnimatedBackgroundCircles> createState() =>
      _AnimatedBackgroundCirclesState();
}

class _AnimatedBackgroundCirclesState extends State<AnimatedBackgroundCircles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation1;
  late Animation<double> _rotationAnimation2;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );

    _rotationAnimation1 = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _rotationAnimation2 = Tween<double>(
      begin: 0.0,
      end: -1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Top-left circle (larger, blue)
          Positioned(
            left: -200.w,
            top: -250.h,
            child: AnimatedBuilder(
              animation: _rotationAnimation1,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation1.value * 2 * 3.14159265359,
                  child: child,
                );
              },
              child: Container(
                width: 500.w,
                height: 600.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF51A2FF).withValues(alpha: 0.1),
                ),
              ),
            ),
          ),

          // Bottom-right circle (smaller, lighter blue)
          Positioned(
            left: 85.w,
            top: 537.h,
            child: AnimatedBuilder(
              animation: _rotationAnimation2,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation2.value * 2 * 3.14159265359,
                  child: child,
                );
              },
              child: Container(
                width: 390.w,
                height: 390.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF8EC5FF).withValues(alpha: 0.1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
