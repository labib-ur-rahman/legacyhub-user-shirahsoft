import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legacyhub/core/services/local_storage_service.dart';
import 'package:legacyhub/core/services/logger_service.dart';
import 'package:legacyhub/features/personalization/onboarding/models/onboarding_page_config.dart';
import 'package:legacyhub/routes/app_routes.dart';

/// ============================================================================
/// ONBOARDING CONTROLLER
/// ============================================================================
/// Manages the onboarding flow state, page navigation, and completion logic.
///
/// Responsibilities:
/// - PageView navigation via PageController
/// - Current page index tracking (reactive)
/// - Skip, Next, Get Started actions
/// - Mark onboarding complete in local storage
/// - Navigate to login after completion
///
/// Architecture:
/// - Pure logic controller — zero UI code
/// - Reactive state via Rx observables
/// - Accessed via static instance pattern
/// ============================================================================

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();

  // ============================================================================
  // STATE
  // ============================================================================

  /// Page controller for PageView
  late final PageController pageController;

  /// Current page index (reactive)
  final RxInt currentPage = 0.obs;

  /// Total number of onboarding pages
  final int totalPages = OnboardingPagesData.pages.length;

  /// Pages configuration data
  List<OnboardingPageConfig> get pages => OnboardingPagesData.pages;

  /// Whether user is on the last page
  bool get isLastPage => currentPage.value == totalPages - 1;

  /// Whether user is on the first page
  bool get isFirstPage => currentPage.value == 0;

  // ============================================================================
  // LIFECYCLE
  // ============================================================================

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
    LoggerService.info(
      'OnboardingController initialized with $totalPages pages',
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // ============================================================================
  // PAGE NAVIGATION
  // ============================================================================

  /// Called when user swipes or PageView changes page
  void onPageChanged(int index) {
    currentPage.value = index;
    LoggerService.info('Onboarding page changed to: $index');
  }

  /// Navigate to the next page with smooth animation
  void nextPage() {
    if (isLastPage) {
      completeOnboarding();
      return;
    }

    pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  /// Navigate to a specific page (dot indicator click)
  void goToPage(int index) {
    if (index < 0 || index >= totalPages) return;

    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  /// Skip to the last page
  void skipToEnd() {
    pageController.animateToPage(
      totalPages - 1,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  // ============================================================================
  // COMPLETION
  // ============================================================================

  /// Complete onboarding and navigate to login
  void completeOnboarding() {
    try {
      // Mark first time as complete
      LocalStorageService.setNotFirstTime();
      LoggerService.info('Onboarding completed — navigating to login');

      // Navigate to login and remove all previous routes
      Get.offAllNamed(AppRoutes.LOGIN);
    } catch (error) {
      LoggerService.error('Error completing onboarding', error);
      // Fallback navigation
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }

  // ============================================================================
  // HELPERS
  // ============================================================================

  /// Get current page config
  OnboardingPageConfig get currentPageConfig => pages[currentPage.value];

  /// Get gradient for current page
  List<Color> get currentGradient => currentPageConfig.gradientColors;
}
