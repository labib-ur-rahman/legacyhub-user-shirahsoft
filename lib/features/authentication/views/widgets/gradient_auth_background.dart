import 'package:flutter/material.dart';
import 'package:legacyhub/features/authentication/views/widgets/animated_star_background.dart';
import 'package:legacyhub/features/authentication/views/widgets/floating_circle_background.dart';

/// Gradient auth background used across all authentication screens
/// Combines: gradient, floating circles, and animated star dots
class GradientAuthBackground extends StatelessWidget {
  final Widget child;

  const GradientAuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00C6FF), Color(0xFF006AED)],
        ),
      ),
      child: Stack(
        children: [
          // Animated star/dot particles
          const Positioned.fill(
            child: AnimatedStarBackground(
              starCount: 50,
              starColor: Colors.white,
            ),
          ),

          // Floating circles
          const Positioned.fill(child: FloatingCircleBackground()),

          // Actual content
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}
