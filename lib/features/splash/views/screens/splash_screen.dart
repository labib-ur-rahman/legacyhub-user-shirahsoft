import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:legacyhub/core/utils/constants/image_path.dart';
import 'package:legacyhub/core/utils/constants/svg_path.dart';
import 'package:legacyhub/core/utils/helpers/svg_icon_helper.dart';
import 'package:legacyhub/features/splash/controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());

    return Scaffold(
      backgroundColor: const Color(0xFFEEEFFC),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          controller.circle1Controller,
          controller.circle2Controller,
          controller.logoController,
          controller.dotLineController,
          controller.circularDotsController,
        ]),
        builder: (context, child) {
          return Stack(
            children: [
              // Stage 3: Second circle (larger, outer)
              Center(
                child: Opacity(
                  opacity: controller.circle2Opacity.value,
                  child: Transform.scale(
                    scale: controller.circle2Scale.value,
                    child: Container(
                      width: 371.w,
                      height: 371.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFD4DCFF).withValues(alpha: 0.6),
                            const Color(0xFFEEEFFC).withValues(alpha: 0.1),
                          ],
                          stops: const [0.0, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Stage 2: First circle (smaller, inner)
              Center(
                child: Opacity(
                  opacity: controller.circle1Opacity.value,
                  child: Transform.scale(
                    scale: controller.circle1Scale.value,
                    child: Container(
                      width: 175.w,
                      height: 175.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFB8C7FF).withValues(alpha: 0.8),
                            const Color(0xFFD4DCFF).withValues(alpha: 0.3),
                          ],
                          stops: const [0.0, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Stage 5: Dot line pattern
              Center(
                child: Opacity(
                  opacity: controller.dotLineOpacity.value,
                  child: SizedBox(
                    width: 246.w,
                    height: 622.5.h,
                    child: Image.asset(ImagePath.dotLine, fit: BoxFit.contain),
                  ),
                ),
              ),

              // Stage 6: Circular dots at specific positions
              _buildCircularDots(controller),

              // Stage 4: App logo in center
              Center(
                child: Opacity(
                  opacity: controller.logoOpacity.value,
                  child: Transform.scale(
                    scale: controller.logoScale.value,
                    child: SizedBox(
                      width: 175.w,
                      height: 167.473.h,
                      child: Image.asset(
                        ImagePath.appLogo,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCircularDots(SplashController controller) {
    // Positions for circular dots based on Figma design
    final List<Map<String, double>> dotPositions = [
      {'left': 24.w, 'top': 89.h}, // Calling icon position
      {'left': 233.w, 'top': 174.h}, // Buy icon position
      {'left': 54.w, 'top': 257.h}, // Home icon position
      {'left': 55.w, 'top': 585.h}, // Heart icon position
      {'left': 110.w, 'top': 724.h}, // Location icon position
      {'left': 227.w, 'top': 622.h}, // Calendar icon position
    ];

    return Opacity(
      opacity: controller.circularDotsOpacity.value,
      child: Stack(
        children: dotPositions.map((position) {
          return Positioned(
            left: position['left'],
            top: position['top'],
            child: _buildAnimatedDot(
              delay: dotPositions.indexOf(position) * 0.1,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAnimatedDot({required double delay}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: (400 + delay * 100).toInt()),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: SvgIconHelper.buildIcon(
              assetPath: SvgPath.circularDot,
              width: 37.w,
              height: 37.h,
            ),
          ),
        );
      },
    );
  }
}
