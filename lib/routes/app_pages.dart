import 'package:get/get.dart';
import 'package:legacyhub/features/authentication/views/screens/login_screen.dart';
import 'package:legacyhub/features/home/views/screens/home_screen.dart';
import 'package:legacyhub/features/main/views/screens/main_screen.dart';
import 'package:legacyhub/features/onboarding/views/screens/language_screen.dart';
import 'package:legacyhub/features/onboarding/views/screens/style_screen.dart';
import 'package:legacyhub/features/onboarding/views/screens/theme_screen.dart';
import 'package:legacyhub/features/splash/views/screens/splash_screen.dart';

import 'app_routes.dart';

/// App Pages - Maps routes to their corresponding pages and bindings
/// This is where we define which screen should be shown for each route
class AppPages {
  AppPages._();

  /// List of all app pages with their routes, screens, and bindings
  static List<GetPage> routes = [
    // ==================== Splash Screen ====================
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // ==================== Onboarding Screens ====================
    GetPage(
      name: AppRoutes.THEME_SELECTION,
      page: () => const ThemeScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.LANGUAGE_SELECTION,
      page: () => const LanguageScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.STYLE_SELECTION,
      page: () => const StyleScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 400),
    ),

    // ==================== Authentication Screens ====================
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),

    // ==================== Main App Screens ====================
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.MAIN,
      page: () => const MainScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
