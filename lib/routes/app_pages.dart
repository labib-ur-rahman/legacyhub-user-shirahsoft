import 'package:get/get.dart';
import 'package:project_template/features/home/examples/home_screen.dart';

import 'app_routes.dart';

/// App Pages - Maps routes to their corresponding pages and bindings
/// This is where we define which screen should be shown for each route
class AppPages {
  AppPages._();

  /// List of all app pages with their routes, screens, and bindings
  static List<GetPage> routes = [
    // ==================== Main App Screens ====================
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeScreen(),
      // binding: HomeBinding(), // Uncomment when binding is created
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
