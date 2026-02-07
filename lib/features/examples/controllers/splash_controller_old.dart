import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legacyhub/core/common/widgets/appbar/custom_app_bar.dart';
import 'package:legacyhub/core/services/local_storage_service.dart';
import 'package:legacyhub/core/services/logger_service.dart';
import 'package:legacyhub/routes/app_routes.dart';

/// Splash Controller - Manages splash screen animations and navigation logic
///
/// Responsibilities:
/// - Control splash screen animations
/// - Check first-time user status
/// - Check user authentication status
/// - Navigate to appropriate screen based on user state
///
/// Navigation Flow:
/// 1. First-time user → Theme Selection → Language Selection → Login
/// 2. Returning user (not logged in) → Login
/// 3. Logged in user → Main Screen
class SplashControllerOld extends GetxController
    with GetTickerProviderStateMixin {
  static SplashControllerOld get instance => Get.find();

  // Animation controllers for each stage
  late AnimationController circle1Controller;
  late AnimationController circle2Controller;
  late AnimationController logoController;
  late AnimationController dotLineController;
  late AnimationController circularDotsController;

  // Animations
  late Animation<double> circle1Scale;
  late Animation<double> circle1Opacity;
  late Animation<double> circle2Scale;
  late Animation<double> circle2Opacity;
  late Animation<double> logoScale;
  late Animation<double> logoOpacity;
  late Animation<double> dotLineOpacity;
  late Animation<double> circularDotsOpacity;

  // Loading state
  final RxBool isNavigating = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _startAnimationSequence();
  }

  /// Initialize all animation controllers and animations
  void _initializeAnimations() {
    // Stage 2: First circle (175x175)
    circle1Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    circle1Scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: circle1Controller, curve: Curves.easeOutBack),
    );
    circle1Opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: circle1Controller, curve: Curves.easeIn));

    // Stage 3: Second circle (371x371)
    circle2Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    circle2Scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: circle2Controller, curve: Curves.easeOutBack),
    );
    circle2Opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: circle2Controller, curve: Curves.easeIn));

    // Stage 4: Logo
    logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: logoController, curve: Curves.elasticOut),
    );
    logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: logoController, curve: Curves.easeIn));

    // Stage 5: Dot line
    dotLineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    dotLineOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: dotLineController, curve: Curves.easeIn));

    // Stage 6: Circular dots
    circularDotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    circularDotsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: circularDotsController, curve: Curves.easeIn),
    );
  }

  /// Start the animation sequence and handle navigation
  Future<void> _startAnimationSequence() async {
    try {
      // Stage 1: Blank page (500ms)
      await Future.delayed(const Duration(milliseconds: 500));

      // Stage 2: First circle appears
      await circle1Controller.forward();
      await Future.delayed(const Duration(milliseconds: 300));

      // Stage 3: Second circle appears
      await circle2Controller.forward();
      await Future.delayed(const Duration(milliseconds: 300));

      // Stage 4: Logo appears
      await logoController.forward();
      await Future.delayed(const Duration(milliseconds: 400));

      // Stage 5: Dot line appears
      await dotLineController.forward();
      await Future.delayed(const Duration(milliseconds: 300));

      // Stage 6: Circular dots appear
      await circularDotsController.forward();
      await Future.delayed(const Duration(milliseconds: 1000));

      // Navigate based on user state
      await _navigateToNextScreen();
    } catch (error) {
      LoggerService.error('Splash animation error', error);
      // Fallback navigation in case of error
      await _navigateToNextScreen();
    }
  }

  /// Determine and navigate to the appropriate screen
  Future<void> _navigateToNextScreen() async {
    if (isNavigating.value) return;
    isNavigating.value = true;

    try {
      // Check if user is first-time
      final isFirstTime = LocalStorageService.isFirstTime();
      LoggerService.info('Is first time user: $isFirstTime');

      if (isFirstTime) {
        // First-time user → Go to theme selection
        LoggerService.info('Navigating to Theme Screen');
        Get.offAllNamed(AppRoutes.getLoginScreen());
        return;
      }

      // Check if user is logged in
      final isLoggedIn = await _checkLoginStatus();
      LoggerService.info('Is user logged in: $isLoggedIn');

      if (isLoggedIn) {
        // Logged in user → Go to main screen
        LoggerService.info('Navigating to Main Screen');
        Get.offAllNamed(AppRoutes.getMainScreen());
      } else {
        // Not logged in → Go to login screen
        LoggerService.info('Navigating to Login Screen');
        Get.offAll(() => const CustomAppBar(pageTitle: "Home"));
        // Get.offAllNamed(AppRoutes.getHomeScreen());
      }
    } catch (error) {
      LoggerService.error('Navigation error', error);
      // Default fallback to login
      Get.offAllNamed(AppRoutes.getLoginScreen());
    } finally {
      isNavigating.value = false;
    }
  }

  /// Check if user is logged in
  /// TODO: Implement actual authentication check
  Future<bool> _checkLoginStatus() async {
    try {
      // Check for access token or user session
      // For now, returning false as a placeholder
      // Replace with actual authentication logic
      final accessToken = await LocalStorageService.getAccessToken();
      return accessToken != null && accessToken.isNotEmpty;
    } catch (error) {
      LoggerService.error('Error checking login status', error);
      return false;
    }
  }

  @override
  void onClose() {
    // Dispose all animation controllers
    circle1Controller.dispose();
    circle2Controller.dispose();
    logoController.dispose();
    dotLineController.dispose();
    circularDotsController.dispose();
    super.onClose();
  }
}
