import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Splash Background - Animated gradient background with floating particles
///
/// Features:
/// - Linear gradient (#00C6FF to #006AED)
/// - Animated floating particles (bubbles)
/// - Smooth, lightweight animation
/// - Minimal performance impact
class SplashBackground extends StatefulWidget {
  const SplashBackground({super.key});

  @override
  State<SplashBackground> createState() => _SplashBackgroundState();
}

class _SplashBackgroundState extends State<SplashBackground>
    with TickerProviderStateMixin {
  // Particle list
  final List<_Particle> _particles = [];

  // Animation controller for particles
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _initializeParticles();
    _startParticleAnimation();
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  /// Initialize particles with random positions
  void _initializeParticles() {
    final random = Random();

    // Create 12-15 small circular particles (lightweight)
    final particleCount = 12 + random.nextInt(4);

    for (int i = 0; i < particleCount; i++) {
      final isVisible = random.nextDouble() > 0.4; // 60% visible

      _particles.add(
        _Particle(
          id: i,
          size: 4.0 + random.nextDouble() * 10.0, // 4-14px
          x: random.nextDouble(), // 0.0 - 1.0 (percentage)
          y: random.nextDouble(), // 0.0 - 1.0 (percentage)
          opacity: isVisible
              ? (0.25 + random.nextDouble() * 0.25)
              : 0.08, // 0.08 - 0.5
          speedX: (random.nextDouble() - 0.5) * 0.0003, // Slow horizontal
          speedY: (random.nextDouble() - 0.5) * 0.0005, // Slow vertical
          isStar: false,
        ),
      );
    }

    // Add 2 yellow star particles (top left and right)
    _particles.add(
      _Particle(
        id: particleCount,
        size: 24.w,
        x: 0.08,
        y: 0.15,
        opacity: 0.85,
        speedX: 0.0001,
        speedY: 0.00015,
        isStar: true, // Yellow star
      ),
    );

    _particles.add(
      _Particle(
        id: particleCount + 1,
        size: 20.w,
        x: 0.92,
        y: 0.18,
        opacity: 0.8,
        speedX: -0.00012,
        speedY: 0.00018,
        isStar: true, // Yellow star
      ),
    );

    // Add 2 large decorative circles
    _particles.add(
      _Particle(
        id: particleCount + 2,
        size: 280.w,
        x: -0.15,
        y: -0.2,
        opacity: 0.18,
        speedX: 0.00008,
        speedY: 0.00012,
        isLarge: true,
      ),
    );

    _particles.add(
      _Particle(
        id: particleCount + 3,
        size: 220.w,
        x: -0.08,
        y: 0.7,
        opacity: 0.14,
        speedX: -0.0001,
        speedY: -0.00008,
        isLarge: true,
      ),
    );
  }

  /// Start particle animation
  void _startParticleAnimation() {
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60), // Long loop
    )..repeat();

    _particleController.addListener(() {
      setState(() {
        for (var particle in _particles) {
          particle.update();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF00C6FF), // Top: #00C6FF
            Color(0xFF006AED), // Bottom: #006AED
          ],
        ),
      ),
      child: Stack(
        children: _particles.map((particle) {
          return _buildParticle(particle);
        }).toList(),
      ),
    );
  }

  /// Build individual particle
  Widget _buildParticle(_Particle particle) {
    return Positioned(
      left: particle.x * MediaQuery.of(context).size.width,
      top: particle.y * MediaQuery.of(context).size.height,
      child: Opacity(
        opacity: particle.opacity,
        child: particle.isStar ? _buildStar(particle) : _buildDot(particle),
      ),
    );
  }

  /// Build star particle
  Widget _buildStar(_Particle particle) {
    return SizedBox(
      width: particle.size,
      height: particle.size,
      child: CustomPaint(painter: _StarPainter()),
    );
  }

  /// Build circular dot particle
  Widget _buildDot(_Particle particle) {
    return Container(
      width: particle.size,
      height: particle.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: particle.isLarge
            ? RadialGradient(
                colors: [
                  Colors.white.withValues(alpha:0.3),
                  Colors.white.withValues(alpha:0.15),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              )
            : null,
        color: particle.isLarge ? null : Colors.white,
      ),
    );
  }
}

/// Particle data class
class _Particle {
  final int id;
  final double size;
  double x;
  double y;
  final double opacity;
  final double speedX;
  final double speedY;
  final bool isLarge;
  final bool isStar;

  _Particle({
    required this.id,
    required this.size,
    required this.x,
    required this.y,
    required this.opacity,
    required this.speedX,
    required this.speedY,
    this.isLarge = false,
    this.isStar = false,
  });

  /// Update particle position
  void update() {
    x += speedX;
    y += speedY;

    // Wrap around screen (infinite loop)
    if (x < -0.2) x = 1.2;
    if (x > 1.2) x = -0.2;
    if (y < -0.2) y = 1.2;
    if (y > 1.2) y = -0.2;
  }
}

/// Star painter for drawing 4-pointed stars
class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color =
          const Color(0xFFFFD700) // Gold/yellow color
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    // Draw 4-pointed star
    final path = Path();

    // Top point
    path.moveTo(centerX, centerY - radius);

    // Right point
    path.lineTo(centerX + radius * 0.35, centerY - radius * 0.35);
    path.lineTo(centerX + radius, centerY);

    // Bottom point
    path.lineTo(centerX + radius * 0.35, centerY + radius * 0.35);
    path.lineTo(centerX, centerY + radius);

    // Left point
    path.lineTo(centerX - radius * 0.35, centerY + radius * 0.35);
    path.lineTo(centerX - radius, centerY);

    // Back to top
    path.lineTo(centerX - radius * 0.35, centerY - radius * 0.35);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_StarPainter oldDelegate) => false;
}
