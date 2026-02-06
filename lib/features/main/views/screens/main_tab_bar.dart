import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legacyhub/core/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:legacyhub/core/utils/constants/svg_path.dart';
import 'package:legacyhub/core/utils/constants/app_style_colors.dart';
import 'package:legacyhub/core/utils/helpers/svg_icon_helper.dart';
import 'package:legacyhub/features/main/controllers/main_header_controller.dart';
import 'package:legacyhub/features/main/views/widgets/brand_logo.dart';
import 'package:legacyhub/features/main/views/widgets/tab_icon.dart';
import 'package:legacyhub/features/main/views/widgets/profile_tab_icon.dart';

/// Main tab bar with LegacyHub header design using Material TabBar
/// Matches Figma design: node-id 468-5917
///
/// Features:
/// - Gradient background based on app style
/// - Curved bottom corners (30px radius) using SLCurvedEdgeWidget
/// - Brand logo "LegacyHub" + Screen title (collapsible on scroll)
/// - Inbox and Menu action buttons (collapsible on scroll)
/// - 5 icon tabs: Home, Projects, Shop, Activities, Profile
/// - Smooth animation when collapsing/expanding header on scroll
class MainTabBar extends StatelessWidget {
  const MainTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MainHeaderController.instance;

    return AnimatedBuilder(
      animation: controller.headerAnimationController,
      builder: (context, child) {
        // Calculate current curve radius based on animation
        final curveRadius = 30.0 * controller.curveAnimation.value;

        return SLCurvedEdgeWidget(
          cornerRadius: curveRadius,
          child: Container(
            decoration: BoxDecoration(
              gradient: AppStyleColors.instance.appBarGradient,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// -- Status Bar Space
                SizedBox(height: MediaQuery.of(context).padding.top),

                /// -- Header Content (Brand Logo, Screen Title, Inbox, Menu)
                /// Animated height based on scroll
                SizeTransition(
                  sizeFactor: controller.headerAnimation,
                  axisAlignment: -1.0,
                  child: FadeTransition(
                    opacity: controller.headerAnimation,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(24.w, 0.h, 24.w, 8.h),
                      child: Row(
                        children: [
                          /// -- Brand Logo (LegacyHub)
                          const BrandLogo(),

                          6.horizontalSpace,

                          /// -- Vertical Divider
                          Container(
                            margin: EdgeInsets.only(top: 8.h),
                            height: 16.h,
                            width: 2.w,
                            color: Colors.white,
                          ),

                          6.horizontalSpace,

                          /// -- Screen Title (using Imperial Script font)
                          Obx(
                            () => Transform.translate(
                              offset: Offset(
                                0,
                                20 *
                                    (1.0 -
                                        controller
                                            .headerAnimation
                                            .value), // Move up on collapse
                              ),

                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  controller.screenTitle,
                                  style: GoogleFonts.imperialScript(
                                    fontSize: 22.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const Spacer(),

                          /// -- Inbox Icon
                          GestureDetector(
                            onTap: () => controller.showInbox(),
                            child: SvgIconHelper.buildIcon(
                              assetPath: SvgPath.messageUnselected,
                              width: 24.w,
                              height: 24.h,
                              color: Colors.white,
                            ),
                          ),

                          16.horizontalSpace,

                          /// -- Menu Icon
                          GestureDetector(
                            onTap: () => controller.openDrawer(),
                            child: SvgIconHelper.buildIcon(
                              assetPath: SvgPath.menu,
                              width: 24.w,
                              height: 24.h,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// -- Tab Bar with 5 Icon Tabs (Always visible)
                /// Hide indicator when Inbox is visible
                Theme(
                  data: Theme.of(context).copyWith(
                    splashColor: Colors.white.withValues(alpha: 0.2),
                    highlightColor: Colors.white.withValues(alpha: 0.1),
                    splashFactory: InkRipple.splashFactory,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: Obx(
                      () => TabBar(
                        controller: controller.tabController,
                        onTap: (index) => controller.changeTab(index),
                        // Hide indicator when inbox is visible
                        indicatorColor: controller.isInboxVisible
                            ? Colors.transparent
                            : Colors.white,
                        indicatorWeight: 3,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelPadding: EdgeInsets.zero,
                        dividerColor: Colors.transparent,
                        // Circular splash effect
                        splashBorderRadius: BorderRadius.circular(50.r),
                        overlayColor: WidgetStateProperty.all(
                          Colors.white.withValues(alpha: 0.15),
                        ),
                        tabs: [
                          /// -- Home Tab
                          TabIcon(
                            iconPath: controller.isTabActive(0)
                                ? SvgPath.tabHomeSelected
                                : SvgPath.tabHomeUnselected,
                            isActive: controller.isTabActive(0),
                          ),

                          /// -- Projects Tab
                          TabIcon(
                            iconPath: controller.isTabActive(1)
                                ? SvgPath.projectsSelected
                                : SvgPath.projectsUnselected,
                            isActive: controller.isTabActive(1),
                          ),

                          /// -- Shop Tab
                          TabIcon(
                            iconPath: controller.isTabActive(2)
                                ? SvgPath.shopSelected
                                : SvgPath.shopUnselected,
                            isActive: controller.isTabActive(2),
                          ),

                          /// -- Activities/Notifications Tab
                          TabIcon(
                            iconPath: controller.isTabActive(3)
                                ? SvgPath.notificationSelected
                                : SvgPath.notificationUnselected,
                            isActive: controller.isTabActive(3),
                            showDot: true, // Show notification dot
                          ),

                          /// -- Profile Tab (uses network image)
                          ProfileTabIcon(
                            isActive: controller.isTabActive(4),
                            imageUrl:
                                'https://avatars.githubusercontent.com/u/177158869',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 8.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
