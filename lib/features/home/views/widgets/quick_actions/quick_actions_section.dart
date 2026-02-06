import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/core/localization/app_string_localizations.dart';

/// Quick Actions Section - Horizontal scrollable action buttons
/// Contains: Recharge, Micro Jobs, Drive Offers, Reselling, Buy & Sell, On-Demand, My Network
/// Design: Static section, always visible, no loading animation
class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.only(
        top: 20.h,
        bottom: 20.h,
        left: 20.w,
        right: 20.w,
      ),
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
                colors: [const Color(0xFF1E1E2E), const Color(0xFF2A2A3E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [Colors.white, const Color(0xFFF8F9FA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: isDark
            ? Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1)
            : null,
      ),
      child: SizedBox(
        height: 96.h,
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          children: [
            /// Recharge - Blue
            _buildQuickActionItem(
              icon: Iconsax.flash_1,
              label: AppStrings.recharge,
              bgColor: const Color(0xFFDBEAFE).withValues(alpha: 0.4),
              iconColor: const Color(0xFF2563EB),
              isDark: isDark,
              onTap: () {},
            ),
            SizedBox(width: 12.w),

            /// Micro Jobs - Purple
            _buildQuickActionItem(
              icon: Iconsax.briefcase,
              label: AppStrings.microJobs,
              bgColor: const Color(0xFFF3E8FF).withValues(alpha: 0.4),
              iconColor: const Color(0xFF9333EA),
              isDark: isDark,
              onTap: () {},
            ),
            SizedBox(width: 12.w),

            /// Drive Offers - Indigo
            _buildQuickActionItem(
              icon: Iconsax.simcard,
              label: 'Drive Offers',
              bgColor: const Color(0xFFE0E7FF).withValues(alpha: 0.4),
              iconColor: const Color(0xFF4F46E5),
              isDark: isDark,
              onTap: () {},
            ),
            SizedBox(width: 12.w),

            /// Reselling - Green
            _buildQuickActionItem(
              icon: Iconsax.shop,
              label: AppStrings.reselling,
              bgColor: const Color(0xFFDCFCE7).withValues(alpha: 0.4),
              iconColor: const Color(0xFF16A34A),
              isDark: isDark,
              onTap: () {},
            ),
            SizedBox(width: 12.w),

            /// Buy & Sell - Orange
            _buildQuickActionItem(
              icon: Iconsax.shopping_bag,
              label: 'Buy & Sell',
              bgColor: const Color(0xFFFFEDD4).withValues(alpha: 0.4),
              iconColor: const Color(0xFFEA580C),
              isDark: isDark,
              onTap: () {},
            ),
            SizedBox(width: 12.w),

            /// On-Demand - Rose/Pink
            _buildQuickActionItem(
              icon: Iconsax.search_normal,
              label: 'On-Demand',
              bgColor: const Color(0xFFFFE4E6).withValues(alpha: 0.4),
              iconColor: const Color(0xFFE11D48),
              isDark: isDark,
              onTap: () {},
            ),
            SizedBox(width: 12.w),

            /// My Network - Violet
            _buildQuickActionItem(
              icon: Iconsax.people,
              label: 'My Network',
              bgColor: const Color(0xFFEDE9FE).withValues(alpha: 0.4),
              iconColor: const Color(0xFF7C3AED),
              isDark: isDark,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  /// Build single quick action item with circular icon and enhanced design
  Widget _buildQuickActionItem({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color iconColor,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 76.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// -- Circular Icon Container with enhanced design
            Container(
              width: 68.w,
              height: 68.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isDark
                    ? LinearGradient(
                        colors: [
                          iconColor.withValues(alpha: 0.2),
                          iconColor.withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [
                          bgColor.withValues(alpha: 0.8),
                          bgColor.withValues(alpha: 0.4),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                boxShadow: [
                  BoxShadow(
                    color: iconColor.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: iconColor.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                size: 30.sp,
                color: iconColor,
                shadows: [
                  Shadow(
                    color: iconColor.withValues(alpha: 0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            /// -- Label with better typography
            SizedBox(
              height: 16.h,
              child: Text(
                label,
                style: getTextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white : const Color(0xFF1F2937),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
