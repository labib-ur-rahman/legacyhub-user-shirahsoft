import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/features/personalization/onboarding/models/onboarding_page_config.dart';
import 'package:legacyhub/features/personalization/onboarding/views/widgets/onboarding_lottie.dart';
import 'package:legacyhub/features/personalization/onboarding/views/widgets/onboarding_text.dart';

/// ============================================================================
/// ONBOARDING PAGE
/// ============================================================================
/// Individual onboarding page widget rendered inside PageView.
///
/// Layout (from Figma):
/// - Gradient background (handled by parent)
/// - Glass card container (white 10% bg, rounded 32px, shadow)
///   - Lottie animation with glow
///   - Title (Bebas Neue / K2D)
///   - Subtitle (Inter Bold)
///   - Description OR Feature List
///
/// Uses AutomaticKeepAliveClientMixin to prevent unnecessary rebuilds
/// when swiping between pages.
/// ============================================================================

class OnboardingPage extends StatefulWidget {
  final OnboardingPageConfig config;
  final int pageIndex;

  const OnboardingPage({
    super.key,
    required this.config,
    required this.pageIndex,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final config = widget.config;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Center(child: _buildGlassCard(config)),
    );
  }

  /// Glass morphism card matching Figma design
  Widget _buildGlassCard(OnboardingPageConfig config) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 50,
            offset: const Offset(0, 25),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 32.w, right: 32.w, bottom: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (config.showFeatureList && config.features != null)
              SizedBox(height: 20.h),

            // Lottie animation
            OnboardingLottie(
              lottieAsset: config.lottieAsset,
              glowColor: config.glowColor,
              pageIndex: widget.pageIndex,
            ),

            SizedBox(
              height: (config.showFeatureList && config.features != null)
                  ? 0
                  : 12.h,
            ),

            // Text content
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OnboardingText(
                  title: config.titleKey.tr,
                  subtitle: config.subtitleKey.tr,
                  description: config.descriptionKey?.tr,
                  pageIndex: widget.pageIndex,
                ),

                // Feature list for last screen
                if (config.showFeatureList && config.features != null) ...[
                  SizedBox(height: 16.h),
                  _buildFeatureList(config.features!),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Feature list for Screen 4 matching Figma design
  Widget _buildFeatureList(List<OnboardingFeatureItem> features) {
    return SizedBox(
      height: 270.h,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white,
              Colors.white.withValues(alpha: 0.0),
            ],
            stops: const [0.0, 0.85, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: ListView.separated(
          padding: EdgeInsets.only(right: 8.w),
          physics: const BouncingScrollPhysics(),
          itemCount: features.length,
          separatorBuilder: (_, __) => SizedBox(height: 8.h),
          itemBuilder: (context, index) {
            return _buildFeatureItem(features[index]);
          },
        ),
      ),
    );
  }

  /// Single feature item matching Figma design
  Widget _buildFeatureItem(OnboardingFeatureItem feature) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon circle
          Container(
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                feature.icon,
                size: 14.sp,
                color: const Color(0xFF101828),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Feature text
          Expanded(
            child: Text(
              feature.textKey.tr,
              style: getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.95),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          SizedBox(width: 12.w),

          // Number badge
          Container(
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${feature.number}',
                style: getK2DTextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
