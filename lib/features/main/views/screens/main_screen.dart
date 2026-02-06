import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:legacyhub/core/utils/constants/app_style_colors.dart';
import 'package:legacyhub/features/home/views/screens/home_screen.dart';
import 'package:legacyhub/features/main/controllers/main_header_controller.dart';
import 'package:legacyhub/features/main/views/screens/main_tab_bar.dart';
import 'package:legacyhub/features/main/views/screens/projects_tab.dart';
import 'package:legacyhub/features/main/views/screens/shop_tab.dart';
import 'package:legacyhub/features/main/views/screens/activities_tab.dart';
import 'package:legacyhub/features/main/views/screens/profile_tab.dart';
import 'package:legacyhub/features/main/views/screens/inbox_tab.dart';
import 'package:legacyhub/features/main/views/widgets/app_drawer.dart';

/// Main container with TabBar and TabBarView for swipeable navigation
/// This is the primary screen after login with 5 tabs:
/// - Home: Dashboard with services and features
/// - Projects: User's projects and tasks
/// - Shop: Marketplace and products
/// - Activities: Notifications and activity feed
/// - Profile: User profile and settings
///
/// Features:
/// - Collapsible header on scroll down (hides logo, title, action buttons)
/// - Expandable header on scroll up (shows full header with curve)
/// - Smooth transition animations
/// - Inbox screen overlay accessible from header
/// - Custom drawer with settings and quick access menu
class MainScreen extends StatelessWidget {
  const MainScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    final controller = MainHeaderController.instance;

    // Set initial tab if provided
    if (initialIndex != 0 && initialIndex <= 4) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.changeTab(initialIndex);
      });
    }

    // Get dark mode state for theming
    final isDark = Get.isDarkMode;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // In dark mode, use light icons; in light mode, still use light icons (header is always gradient)
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        // Dark mode: Use dark background; Light mode: Use AppStyleColors background
        backgroundColor: isDark
            ? const Color(0xFF1A1A2E)
            : AppStyleColors.instance.background,
        body: Stack(
          children: [
            /// -- Main Content (Tab Bar + Tab Views)
            Column(
              children: [
                /// -- Tab Bar Header (Collapsible)
                const MainTabBar(),

                /// -- Content Area (Tab View or Inbox)
                Expanded(
                  child: Obx(() {
                    // Show Inbox if visible, otherwise show TabBarView
                    if (controller.isInboxVisible) {
                      return NotificationListener<ScrollNotification>(
                        onNotification: controller.handleScroll,
                        child: const InboxTab(),
                      );
                    }

                    return NotificationListener<ScrollNotification>(
                      onNotification: controller.handleScroll,
                      child: TabBarView(
                        controller: controller.tabController,
                        children: const [
                          /// -- Home Screen (AppStrings.homeTitle)
                          HomeScreen(),

                          /// -- Projects Screen (AppStrings.projects)
                          ProjectsTab(),

                          /// -- Shop Screen (AppStrings.products)
                          ShopTab(),

                          /// -- Activities Screen (AppStrings.notifications)
                          ActivitiesTab(),

                          /// -- Profile Screen (AppStrings.profile)
                          ProfileTab(),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),

            /// -- Custom Drawer Overlay
            Obx(() {
              if (controller.isDrawerOpen) {
                return const AppDrawer();
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
