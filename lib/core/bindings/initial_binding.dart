import 'package:get/get.dart';
import 'package:legacyhub/core/services/connectivity_service.dart';
import 'package:legacyhub/core/services/firebase_service.dart';
import 'package:legacyhub/features/authentication/controllers/auth_controller.dart';
import 'package:legacyhub/features/home/controllers/home_controller.dart';
import 'package:legacyhub/features/main/controllers/main_header_controller.dart';
import 'package:legacyhub/features/onboarding/controllers/style_controller.dart';
import 'package:legacyhub/features/profile/controllers/user_controller.dart';
import 'package:legacyhub/features/rewards/controllers/reward_controller.dart';
import 'package:legacyhub/features/wallet/controllers/wallet_controller.dart';

/// Initial Binding - Sets up initial dependencies when app starts
/// This binding is called when the app launches and sets up global controllers
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // ==================== Firebase Service (MUST BE FIRST) ====================
    // Firebase Service - All Firebase operations
    Get.put<FirebaseService>(FirebaseService(), permanent: true);

    // ==================== Core Services ====================
    // Connectivity Service - Network monitoring
    Get.put<ConnectivityService>(ConnectivityService(), permanent: true);

    // ==================== Onboarding ====================
    // Style Controller - App style management
    Get.put<StyleController>(StyleController(), permanent: true);

    // ==================== Main Navigation ====================
    // Main Header Controller - Tab bar navigation
    Get.put<MainHeaderController>(MainHeaderController(), permanent: true);

    // ==================== Authentication ====================
    // Auth Controller - Firebase auth state management
    Get.put<AuthController>(AuthController(), permanent: true);

    // ==================== User ====================
    // User Controller - Current user data management
    Get.lazyPut<UserController>(() => UserController(), fenix: true);

    // ==================== Wallet ====================
    // Wallet Controller - Wallet and transactions
    Get.lazyPut<WalletController>(() => WalletController(), fenix: true);

    // ==================== Rewards ====================
    // Reward Controller - Streaks and reward points
    Get.lazyPut<RewardController>(() => RewardController(), fenix: true);

    // ==================== Home ====================
    // Home Controller - Main app controller
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
  }
}
