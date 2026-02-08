import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:legacyhub/core/utils/constants/lottie_path.dart';

/// ============================================================================
/// ONBOARDING PAGE CONFIG MODEL
/// ============================================================================
/// Reusable, data-driven configuration model for each onboarding page.
/// Decouples page content from UI widgets for maximum scalability.
///
/// Usage:
///   final page = OnboardingPageConfig(
///     lottieAsset: LottiePath.ob1WelcomeToLegacyHub,
///     titleKey: 'ob_welcome_title',
///     subtitleKey: 'ob_welcome_subtitle',
///     descriptionKey: 'ob_welcome_desc',
///     gradientColors: [Color(0xFF00C6FF), Color(0xFF006AED)],
///   );
/// ============================================================================

class OnboardingPageConfig {
  /// Lottie animation asset path
  final String lottieAsset;

  /// Translation key for the page title
  final String titleKey;

  /// Translation key for the page subtitle
  final String subtitleKey;

  /// Translation key for the page description (null = hidden)
  final String? descriptionKey;

  /// Gradient colors for the background
  final List<Color> gradientColors;

  /// Glow color for the Lottie container
  final Color glowColor;

  /// Whether this page shows a feature list instead of description
  final bool showFeatureList;

  /// Feature list items (only used when showFeatureList = true)
  final List<OnboardingFeatureItem>? features;

  const OnboardingPageConfig({
    required this.lottieAsset,
    required this.titleKey,
    required this.subtitleKey,
    this.descriptionKey,
    required this.gradientColors,
    required this.glowColor,
    this.showFeatureList = false,
    this.features,
  });
}

/// Feature item for the last onboarding screen
class OnboardingFeatureItem {
  /// Translation key for the feature text
  final String textKey;

  /// Icon for the feature
  final IconData icon;

  /// Feature number (1-based)
  final int number;

  const OnboardingFeatureItem({
    required this.textKey,
    required this.icon,
    required this.number,
  });
}

/// ============================================================================
/// DEFAULT ONBOARDING PAGES CONFIGURATION
/// ============================================================================
/// Pre-built configuration matching the Figma designs.
/// Each screen has its own gradient, Lottie, and content.
/// ============================================================================

class OnboardingPagesData {
  OnboardingPagesData._();

  static const List<OnboardingPageConfig> pages = [
    // ==================== Screen 1: Welcome ====================
    OnboardingPageConfig(
      lottieAsset: LottiePath.ob1WelcomeToLegacyHub,
      titleKey: 'ob_welcome_title',
      subtitleKey: 'ob_welcome_subtitle',
      descriptionKey: 'ob_welcome_desc',
      gradientColors: [Color(0xFF00C6FF), Color(0xFF006AED)],
      glowColor: Color(0xFF00C6FF),
    ),

    // ==================== Screen 2: How It Works ====================
    OnboardingPageConfig(
      lottieAsset: LottiePath.ob2HowToWork,
      titleKey: 'ob_how_works_title',
      subtitleKey: 'ob_how_works_subtitle',
      descriptionKey: 'ob_how_works_desc',
      gradientColors: [Color(0xFF00C950), Color(0xFF00A63E)],
      glowColor: Color(0xFF00C950),
    ),

    // ==================== Screen 3: Transparency & Control ====================
    OnboardingPageConfig(
      lottieAsset: LottiePath.ob3TransparencyControl,
      titleKey: 'ob_transparency_title',
      subtitleKey: 'ob_transparency_subtitle',
      descriptionKey: 'ob_transparency_desc',
      gradientColors: [Color(0xFFAD46FF), Color(0xFFE60076)],
      glowColor: Color(0xFFE60076),
    ),

    // ==================== Screen 4: Features ====================
    OnboardingPageConfig(
      lottieAsset: LottiePath.ob4LegacyHubFeatures,
      titleKey: 'ob_features_title',
      subtitleKey: 'ob_features_subtitle',
      gradientColors: [Color(0xFFFF6900), Color(0xFFE17100)],
      glowColor: Color(0xFFFF6900),
      showFeatureList: true,
      features: [
        OnboardingFeatureItem(
          textKey: 'Skill Development & Learning Content',
          icon: Iconsax.book,
          number: 1,
        ),
        OnboardingFeatureItem(
          textKey: 'Buy, Sell & Product Exchange',
          icon: Iconsax.shop,
          number: 2,
        ),
        OnboardingFeatureItem(
          textKey: 'Mobile Recharge & Digital Top-Up',
          icon: Iconsax.mobile,
          number: 3,
        ),
        OnboardingFeatureItem(
          textKey: 'Micro Tasks & Digital Work Activities',
          icon: Iconsax.task_square,
          number: 4,
        ),
        OnboardingFeatureItem(
          textKey: 'Freelancing & Service-Based Tasks',
          icon: Iconsax.briefcase,
          number: 5,
        ),
        OnboardingFeatureItem(
          textKey: 'Drive Offers & Platform Campaigns',
          icon: Iconsax.discount_shape,
          number: 6,
        ),
        OnboardingFeatureItem(
          textKey: 'Blood Donation & Community Support',
          icon: Iconsax.heart,
          number: 7,
        ),
        OnboardingFeatureItem(
          textKey: 'Daily Activity Rewards',
          icon: Iconsax.gift,
          number: 8,
        ),
        OnboardingFeatureItem(
          textKey: 'Referral & Network Participation',
          icon: Iconsax.people,
          number: 9,
        ),
        OnboardingFeatureItem(
          textKey: 'Team Activity Tracking',
          icon: Iconsax.chart_success,
          number: 10,
        ),
        OnboardingFeatureItem(
          textKey: 'Target-Based Activity Programs',
          icon: Iconsax.flag,
          number: 11,
        ),
        OnboardingFeatureItem(
          textKey: 'Performance & Leadership Recognition',
          icon: Iconsax.medal_star,
          number: 12,
        ),
        OnboardingFeatureItem(
          textKey: 'Ranking & Progress Tracking System',
          icon: Iconsax.trend_up,
          number: 13,
        ),
        OnboardingFeatureItem(
          textKey: 'Donation & Charity Support',
          icon: Iconsax.heart_circle,
          number: 14,
        ),
        OnboardingFeatureItem(
          textKey: 'Account Security & Data Management',
          icon: Iconsax.security_safe,
          number: 15,
        ),
      ],
    ),
  ];
}
