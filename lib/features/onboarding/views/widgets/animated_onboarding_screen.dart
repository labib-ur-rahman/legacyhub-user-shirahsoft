import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/features/onboarding/controllers/theme_controller.dart';
import 'package:legacyhub/features/onboarding/views/widgets/animated_background_circles.dart';

class AnimatedOnboardingScreen extends StatefulWidget {
  final Widget lottieWidget;
  final String title;
  final String description;
  final Widget selector;
  final VoidCallback onNext;
  final String bottomText;
  final Color backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final TextStyle? bottomTextStyle;
  final bool showBackgroundCircles;

  const AnimatedOnboardingScreen({
    super.key,
    required this.lottieWidget,
    required this.title,
    required this.description,
    required this.selector,
    required this.onNext,
    required this.bottomText,
    this.backgroundColor = const Color(0xFFEEEFFC),
    this.titleStyle,
    this.descriptionStyle,
    this.bottomTextStyle,
    this.showBackgroundCircles = true,
  });

  @override
  State<AnimatedOnboardingScreen> createState() =>
      _AnimatedOnboardingScreenState();
}

class _AnimatedOnboardingScreenState extends State<AnimatedOnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _titleAnimation;
  late Animation<double> _descriptionAnimation;
  late Animation<double> _selectorAnimation;
  late Animation<double> _buttonAnimation;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<Offset> _descriptionSlideAnimation;
  late Animation<Offset> _selectorSlideAnimation;
  late Animation<Offset> _buttonSlideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Fade animations with staggered timing
    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
      ),
    );

    _descriptionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
      ),
    );

    _selectorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );

    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
      ),
    );

    // Slide animations
    _titleSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
          ),
        );

    _descriptionSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
          ),
        );

    _selectorSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
          ),
        );

    _buttonSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ThemeController.instance;
    final isDark = controller.selectedTheme.value == ThemeMode.dark;

    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: Stack(
        children: [
          // Animated background circles
          if (widget.showBackgroundCircles)
            const Positioned.fill(child: AnimatedBackgroundCircles()),

          // Main content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 40.h),

                  // Animated Lottie
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              },
                          child: SizedBox(
                            key: ValueKey(widget.lottieWidget),
                            child: widget.lottieWidget,
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 40.h),

                  // Animated Title
                  FadeTransition(
                    opacity: _titleAnimation,
                    child: SlideTransition(
                      position: _titleSlideAnimation,
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF38B3FF), Color(0xFF0031FF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(bounds),
                        child: Text(
                          widget.title,
                          style:
                              widget.titleStyle ??
                              getTextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Animated Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FadeTransition(
                      opacity: _descriptionAnimation,
                      child: SlideTransition(
                        position: _descriptionSlideAnimation,
                        child: Text(
                          widget.description,
                          style:
                              widget.descriptionStyle ??
                              getTextStyle(
                                fontSize: 16.sp,
                                color: isDark
                                    ? const Color.fromARGB(255, 238, 239, 240)
                                    : const Color(0xFF6B7280),
                                lineHeight: 1.4,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Animated Selector
                  FadeTransition(
                    opacity: _selectorAnimation,
                    child: SlideTransition(
                      position: _selectorSlideAnimation,
                      child: widget.selector,
                    ),
                  ),

                  SizedBox(height: 70.h),

                  // Animated Next Button
                  FadeTransition(
                    opacity: _buttonAnimation,
                    child: SlideTransition(
                      position: _buttonSlideAnimation,
                      child: GestureDetector(
                        onTap: widget.onNext,
                        child: Container(
                          width: 56.w,
                          height: 56.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00B2FF), Color(0xFF0080FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00B2FF).withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Bottom Status Text with animated transition
                  FadeTransition(
                    opacity: _buttonAnimation,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.2),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        widget.bottomText,
                        key: ValueKey<String>(widget.bottomText),
                        style:
                            widget.bottomTextStyle ??
                            getTextStyle(
                              fontSize: 12.sp,
                              color:
                                  ThemeController
                                          .instance
                                          .selectedTheme
                                          .value ==
                                      ThemeMode.dark
                                  ? const Color.fromARGB(255, 229, 231, 235)
                                  : const Color(0xFF4A5565),
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  SizedBox(height: 60.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
