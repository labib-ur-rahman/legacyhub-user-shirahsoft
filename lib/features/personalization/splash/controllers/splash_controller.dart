import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legacyhub/core/services/firebase_service.dart';
import 'package:legacyhub/core/services/local_storage_service.dart';
import 'package:legacyhub/core/services/logger_service.dart';
import 'package:legacyhub/core/utils/manager/network_manager.dart';
import 'package:legacyhub/data/repositories/user_repository.dart';
import 'package:legacyhub/routes/app_routes.dart';

/// Splash Controller - Handles app initialization and navigation logic
///
/// Flow:
/// 1. Check internet connection
/// 2. Check if first time user → Language screen
/// 3. Check authentication status
/// 4. Check user account status → Navigate accordingly
class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static SplashController get instance => Get.find();

  // ==================== Dependencies ====================
  final _firebase = FirebaseService.instance;
  final _network = NetworkManager.instance;
  final _userRepository = UserRepository();

  // ==================== Animation Controllers ====================
  late AnimationController animationController;

  // ==================== Observables ====================
  final _isInitializing = true.obs;

  // Navigation guard to prevent multiple navigations
  bool _hasNavigated = false;

  // ==================== Getters ====================
  bool get isInitializing => _isInitializing.value;

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _startSplashSequence();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  // ==================== Initialization ====================
  /// Initialize animation controller
  void _initializeAnimations() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    animationController.forward();
  }

  /// Start splash sequence
  Future<void> _startSplashSequence() async {
    try {
      LoggerService.info('🚀 Splash: Starting initialization sequence');

      // Wait minimum splash duration for animations
      await Future.delayed(const Duration(milliseconds: 3000));

      // Step 1: Check internet connection
      final isConnected = await _checkInternetConnection();
      if (!isConnected) {
        LoggerService.warning('⚠️ Splash: No internet connection');
        // Stay on splash, NetworkManager will show popup
        return;
      }

      // Step 2: Check if first time user
      final isFirstTime = await _checkFirstTimeUser();
      if (isFirstTime) {
        LoggerService.info('👤 Splash: First time user detected');
        await _navigateToLanguageSelection();
        return;
      }

      // Step 3: Check authentication
      final isAuthenticated = _checkAuthentication();
      if (!isAuthenticated) {
        LoggerService.info('🔐 Splash: User not authenticated');
        await _navigateToLogin();
        return;
      }

      // Step 4: Check account status
      await _checkAccountStatus();
    } catch (e, stackTrace) {
      LoggerService.error(
        '❌ Splash: Error during initialization',
        e,
        stackTrace,
      );
      // On error, navigate to login as fallback
      await _navigateToLogin();
    } finally {
      _isInitializing.value = false;
    }
  }

  // ==================== Navigation Checks ====================
  /// Check internet connection
  Future<bool> _checkInternetConnection() async {
    try {
      LoggerService.debug('🌐 Splash: Checking internet connection');
      final isConnected = await _network.isConnected();
      return isConnected;
    } catch (e) {
      LoggerService.error('❌ Splash: Failed to check internet', e);
      return false;
    }
  }

  /// Check if first time user
  Future<bool> _checkFirstTimeUser() async {
    try {
      LoggerService.debug('📱 Splash: Checking first time status');
      final isFirstTime = LocalStorageService.isFirstTime();
      return isFirstTime;
    } catch (e) {
      LoggerService.error('❌ Splash: Failed to check first time status', e);
      return false;
    }
  }

  /// Check authentication status
  bool _checkAuthentication() {
    try {
      LoggerService.debug('🔐 Splash: Checking authentication status');
      return _firebase.isAuthenticated;
    } catch (e) {
      LoggerService.error('❌ Splash: Failed to check authentication', e);
      return false;
    }
  }

  /// Check user account status from Firestore
  Future<void> _checkAccountStatus() async {
    try {
      LoggerService.debug('🔍 Splash: Checking user account status');

      // Get current user from Firestore
      final user = await _userRepository.getCurrentUser();

      if (user == null) {
        LoggerService.warning('⚠️ Splash: User document not found');
        await _handleInvalidAccount();
        return;
      }

      // Check account state
      if (user.status.isActive) {
        LoggerService.info('✅ Splash: Account is active');
        await _navigateToMain();
      } else if (user.status.isBanned ||
          user.status.isSuspended ||
          user.status.isDeleted) {
        LoggerService.warning(
          '⛔ Splash: Account is ${user.status.accountState}',
        );
        await _handleInvalidAccount();
      } else {
        LoggerService.warning('⚠️ Splash: Unknown account state');
        await _handleInvalidAccount();
      }
    } catch (e, stackTrace) {
      LoggerService.error(
        '❌ Splash: Failed to check account status',
        e,
        stackTrace,
      );
      // On error, try to navigate to main (let main screen handle it)
      await _navigateToMain();
    }
  }

  /// Handle invalid account (banned/suspended/deleted)
  Future<void> _handleInvalidAccount() async {
    try {
      LoggerService.info('🚪 Splash: Logging out invalid account');
      // Sign out user
      await _firebase.auth.signOut();
      // Navigate to login
      await _navigateToLogin();
    } catch (e, stackTrace) {
      LoggerService.error(
        '❌ Splash: Failed to logout invalid account',
        e,
        stackTrace,
      );
      await _navigateToLogin();
    }
  }

  // ==================== Navigation Methods ====================
  /// Navigate to language selection
  Future<void> _navigateToLanguageSelection() async {
    if (_hasNavigated) {
      LoggerService.warning('⚠️ Splash: Navigation already occurred, skipping');
      return;
    }
    _hasNavigated = true;
    LoggerService.info('🌍 Splash: Navigating to language selection');
    await Get.offNamed(AppRoutes.LANGUAGE_SELECTION);
  }

  /// Navigate to login screen
  Future<void> _navigateToLogin() async {
    if (_hasNavigated) {
      LoggerService.warning('⚠️ Splash: Navigation already occurred, skipping');
      return;
    }
    _hasNavigated = true;
    LoggerService.info('🔐 Splash: Navigating to login');
    await Get.offNamed(AppRoutes.LOGIN);
  }

  /// Navigate to main screen
  Future<void> _navigateToMain() async {
    if (_hasNavigated) {
      LoggerService.warning('⚠️ Splash: Navigation already occurred, skipping');
      return;
    }
    _hasNavigated = true;
    LoggerService.info('🏠 Splash: Navigating to main screen');
    await Get.offNamed(AppRoutes.MAIN);
  }

  // ==================== Public Methods ====================
  /// Retry initialization (called when user taps on splash after error)
  Future<void> retryInitialization() async {
    if (_isInitializing.value) {
      LoggerService.warning('⚠️ Splash: Initialization already in progress');
      return;
    }
    LoggerService.info('🔄 Splash: Retrying initialization');
    _hasNavigated = false; // Reset navigation flag
    _isInitializing.value = true;
    await _startSplashSequence();
  }
}
