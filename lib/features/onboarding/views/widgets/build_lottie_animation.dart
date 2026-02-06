import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class BuildLottieAnimation extends StatelessWidget {
  const BuildLottieAnimation({super.key, required this.lottieAnim});

  final String lottieAnim;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: SizedBox(
              key: ValueKey(lottieAnim),
              width: 230.w,
              height: 230.h,
              child: Lottie.asset(lottieAnim, fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }
}
