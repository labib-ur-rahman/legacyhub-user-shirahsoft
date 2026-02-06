import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:legacyhub/core/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:legacyhub/core/utils/constants/app_style_colors.dart';
import 'package:legacyhub/features/onboarding/controllers/style_controller.dart';

/// Custom App Bar - LegacyHub branded app bar with curved edges
///
/// Features:
/// - Gradient background based on selected app style
/// - Curved bottom edges
/// - App logo and title
/// - Page title with decorative divider
/// - Action buttons (Inbox, Menu)
/// - Optional bottom tab bar
///
/// Usage:
///   CustomAppBar(
///     pageTitle: 'Home',
///     showTabBar: true,
///     onInboxTap: () => navigateToInbox(),
///     onMenuTap: () => openDrawer(),
///   )
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.pageTitle,
    this.showTabBar = false,
    this.tabBar,
    this.onInboxTap,
    this.onMenuTap,
    this.height,
  });

  /// Current page title (e.g., "Home", "Wallet", "Shop")
  final String pageTitle;

  /// Whether to show the bottom tab bar
  final bool showTabBar;

  /// Optional custom tab bar widget
  final Widget? tabBar;

  /// Callback when inbox icon is tapped
  final VoidCallback? onInboxTap;

  /// Callback when menu icon is tapped
  final VoidCallback? onMenuTap;

  /// Custom height for the app bar (default: 159.h)
  final double? height;

  @override
  Size get preferredSize => Size.fromHeight(height ?? 159.h);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StyleController>(
      init: Get.isRegistered<StyleController>()
          ? StyleController.instance
          : Get.put(StyleController()),
      builder: (controller) {
        final styleColors = AppStyleColors.instance;

        return SLCurvedEdgeWidget(
          cornerRadius: 30.r,
          child: Container(
            width: double.infinity,
            height: height ?? 159.h,
            decoration: BoxDecoration(gradient: styleColors.appBarGradient),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // App Bar Content
                  _buildAppBarContent(controller),

                  // Tab Bar (if enabled)
                  if (showTabBar && tabBar != null)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: tabBar,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build the main app bar content (logo, title, actions)
  Widget _buildAppBarContent(StyleController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // App Logo & Title
          _buildLogoSection(),

          // Divider Line
          _buildDivider(),

          // Page Title
          _buildPageTitle(),

          const Spacer(),

          // Action Buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  /// Build the app logo and "LegacyHub" text
  Widget _buildLogoSection() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // App Logo Text
        Text(
          'LegacyHub',
          style: TextStyle(
            fontFamily: 'K2D',
            fontWeight: FontWeight.w800,
            fontSize: 28.sp,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  /// Build the vertical divider between logo and page title
  Widget _buildDivider() {
    return Container(
      height: 16.h,
      width: 1.w,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      color: Colors.white.withValues(alpha: 0.5),
    );
  }

  /// Build the current page title
  Widget _buildPageTitle() {
    return Text(
      pageTitle,
      style: TextStyle(
        fontFamily: 'Imperial Script',
        fontSize: 22.sp,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    );
  }

  /// Build the action buttons (Inbox & Menu)
  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Inbox Button
        _ActionButton(icon: Iconsax.message, onTap: onInboxTap),
        SizedBox(width: 12.w),

        // Menu Button
        _ActionButton(icon: Iconsax.menu, onTap: onMenuTap),
      ],
    );
  }
}

/// Private action button widget for app bar
class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(icon, size: 22.sp, color: Colors.white),
      ),
    );
  }
}

/// Simplified Custom App Bar for screens that need just the gradient header
/// without the full logo section
class CustomAppBarSimple extends StatelessWidget {
  const CustomAppBarSimple({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.height,
  });

  /// Title text or widget
  final String title;

  /// Leading widget (usually back button)
  final Widget? leading;

  /// Action widgets on the right
  final List<Widget>? actions;

  /// Whether to center the title
  final bool centerTitle;

  /// Custom height
  final double? height;

  @override
  Widget build(BuildContext context) {
    final styleColors = AppStyleColors.instance;

    return SLCurvedEdgeWidget(
      cornerRadius: 30.r,
      child: Container(
        width: double.infinity,
        height: height ?? 120.h,
        decoration: BoxDecoration(gradient: styleColors.appBarGradient),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                // Leading
                if (leading != null) leading!,
                if (leading != null) SizedBox(width: 8.w),

                // Title
                if (centerTitle) const Spacer(),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                    color: Colors.white,
                  ),
                ),
                if (centerTitle) const Spacer(),

                // Actions
                if (actions != null) ...actions!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
