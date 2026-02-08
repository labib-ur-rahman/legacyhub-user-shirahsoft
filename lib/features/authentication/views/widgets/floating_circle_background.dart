import 'package:flutter/material.dart';

/// Floating circle decorations for auth background
/// Two semi-transparent circles: one top-left, one bottom-left
class FloatingCircleBackground extends StatefulWidget {
  const FloatingCircleBackground({super.key});

  @override
  State<FloatingCircleBackground> createState() =>
      _FloatingCircleBackgroundState();
}

class _FloatingCircleBackgroundState extends State<FloatingCircleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
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
        final value = _controller.value;
        return Stack(
          children: [
            // Top-right floating circle
            Positioned(
              right: -60 + (value * 20),
              top: -80 + (value * 15),
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
            // Bottom-left floating circle
            Positioned(
              left: -130 + (value * 10),
              bottom: -80 + (value * 20),
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
