import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/core/localization/app_string_localizations.dart';
import 'package:legacyhub/features/personalization/onboarding/controllers/onboarding_controller.dart';
import 'package:legacyhub/features/personalization/onboarding/views/widgets/animated_dot_indicator.dart';
import 'package:legacyhub/features/personalization/onboarding/views/widgets/flash_light_transition.dart';
import 'package:legacyhub/features/personalization/onboarding/views/widgets/onboarding_button.dart';
import 'package:legacyhub/features/personalization/onboarding/views/widgets/onboarding_page.dart';

/// ============================================================================
/// ONBOARDING ENGINE
/// ============================================================================
/// The core engine widget that orchestrates the entire onboarding experience.
///
/// Architecture:
/// - PageView.builder for efficient page rendering
/// - Animated gradient background that transitions between pages
/// - Decorative background circles with radial gradients
/// - Flash light transition overlay
/// - Skip button (hidden on last page)
/// - Dot indicator with clickable navigation
/// - Animated Next / Get Started button
///
/// Performance:
/// - PageView.builder prevents building all pages at once
/// - AutomaticKeepAliveClientMixin on pages prevents rebuilds
/// - Animated background uses lerp for smooth gradient interpolation
/// - const constructors throughout
/// ============================================================================

class OnboardingEngine extends StatelessWidget {
  const OnboardingEngine({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController.instance;

    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          Obx(
            () => _AnimatedGradientBackground(
              currentPage: controller.currentPage.value,
              pageController: controller.pageController,
              pages: controller.pages,
            ),
          ),

          // Decorative background circles
          Obx(
            () => _BackgroundCircles(
              currentPage: controller.currentPage.value,
              pages: controller.pages,
            ),
          ),

          // Flash light transition overlay
          FlashLightTransition(pageController: controller.pageController),

          // Main PageView content
          SafeArea(
            child: Column(
              children: [
                // Skip button row
                Obx(
                  () => _SkipButton(
                    isVisible: !controller.isLastPage,
                    onTap: controller.skipToEnd,
                  ),
                ),

                // PageView (fills remaining space)
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.totalPages,
                    itemBuilder: (context, index) {
                      return OnboardingPage(
                        config: controller.pages[index],
                        pageIndex: index,
                      );
                    },
                  ),
                ),

                // Bottom section: Dots + Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      // Dot indicator
                      Obx(
                        () => AnimatedDotIndicator(
                          currentIndex: controller.currentPage.value,
                          totalDots: controller.totalPages,
                          onDotTapped: controller.goToPage,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Next / Get Started button
                      Obx(
                        () => OnboardingButton(
                          isLastPage: controller.isLastPage,
                          onPressed: controller.isLastPage
                              ? controller.completeOnboarding
                              : controller.nextPage,
                        ),
                      ),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================================
/// ANIMATED GRADIENT BACKGROUND
/// ============================================================================
/// Smoothly transitions gradient colors when swiping between pages.
/// Uses PageController scroll position for real-time interpolation.

class _AnimatedGradientBackground extends StatefulWidget {
  final int currentPage;
  final PageController pageController;
  final List pages;

  const _AnimatedGradientBackground({
    required this.currentPage,
    required this.pageController,
    required this.pages,
  });

  @override
  State<_AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<_AnimatedGradientBackground> {
  double _page = 0;

  @override
  void initState() {
    super.initState();
    _page = widget.currentPage.toDouble();
    widget.pageController.addListener(_onScroll);
  }

  void _onScroll() {
    if (widget.pageController.hasClients) {
      setState(() {
        _page = widget.pageController.page ?? widget.currentPage.toDouble();
      });
    }
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int lowerIndex = _page.floor().clamp(0, widget.pages.length - 1);
    final int upperIndex = (lowerIndex + 1).clamp(0, widget.pages.length - 1);
    final double fraction = _page - lowerIndex;

    // Lerp between gradients
    final Color startColor = Color.lerp(
      widget.pages[lowerIndex].gradientColors[0],
      widget.pages[upperIndex].gradientColors[0],
      fraction,
    )!;
    final Color endColor = Color.lerp(
      widget.pages[lowerIndex].gradientColors[1],
      widget.pages[upperIndex].gradientColors[1],
      fraction,
    )!;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(-0.5, -1.0),
          end: const Alignment(0.5, 1.0),
          colors: [startColor, endColor],
        ),
      ),
    );
  }
}

/// ============================================================================
/// BACKGROUND CIRCLES (decorative)
/// ============================================================================
/// Radial gradient circles matching Figma design.

class _BackgroundCircles extends StatelessWidget {
  final int currentPage;
  final List pages;

  const _BackgroundCircles({required this.currentPage, required this.pages});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.2,
      child: SizedBox.expand(
        child: Stack(
          children: [
            // Top-left circle
            Positioned(
              left: -270.w,
              top: -115.h,
              child: Container(
                width: 393.w,
                height: 393.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.5),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                    stops: const [0.0, 0.7],
                  ),
                ),
              ),
            ),

            // Bottom-right / center circle
            Positioned(
              left: -207.w,
              top: 307.h,
              child: Container(
                width: 542.w,
                height: 542.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.4),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                    stops: const [0.0, 0.7],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// SKIP BUTTON
/// ============================================================================
/// Glassmorphic skip button matching Figma design.
/// Hidden on the last onboarding screen.

class _SkipButton extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onTap;

  const _SkipButton({required this.isVisible, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 24.w, top: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedOpacity(
            opacity: isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedScale(
              scale: isVisible ? 1.0 : 0.8,
              duration: const Duration(milliseconds: 300),
              child: GestureDetector(
                onTap: isVisible ? onTap : null,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(100.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    AppStrings.skip,
                    style: getBoldTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
