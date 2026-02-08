import 'dart:math';

import 'package:flutter/material.dart';

/// Animated star/dot particles background for auth screens
/// Lightweight canvas-based animation for star-like dots
class AnimatedStarBackground extends StatefulWidget {
  final int starCount;
  final Color starColor;

  const AnimatedStarBackground({
    super.key,
    this.starCount = 50,
    this.starColor = Colors.white,
  });

  @override
  State<AnimatedStarBackground> createState() => _AnimatedStarBackgroundState();
}

class _AnimatedStarBackgroundState extends State<AnimatedStarBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Star> _stars;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _stars = List.generate(widget.starCount, (_) => _generateStar());
  }

  _Star _generateStar() {
    return _Star(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      size: _random.nextDouble() * 3 + 1,
      opacity: _random.nextDouble() * 0.5 + 0.2,
      speed: _random.nextDouble() * 0.3 + 0.1,
      phase: _random.nextDouble() * 2 * pi,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _StarPainter(
            stars: _stars,
            color: widget.starColor,
            progress: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Star {
  final double x;
  final double y;
  final double size;
  final double opacity;
  final double speed;
  final double phase;

  _Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.speed,
    required this.phase,
  });
}

class _StarPainter extends CustomPainter {
  final List<_Star> stars;
  final Color color;
  final double progress;

  _StarPainter({
    required this.stars,
    required this.color,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final twinkle =
          (sin((progress * 2 * pi * star.speed) + star.phase) + 1) / 2;
      final opacity = (star.opacity * (0.3 + 0.7 * twinkle)).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StarPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
