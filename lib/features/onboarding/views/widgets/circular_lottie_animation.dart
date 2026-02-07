import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CircularLottieAnimation extends StatelessWidget {
  const CircularLottieAnimation({
    super.key,
    required this.lottieAsset,
    this.size = 200,
  });

  final String lottieAsset;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(lottieAsset, height: size, fit: BoxFit.contain),
    );
  }
}
