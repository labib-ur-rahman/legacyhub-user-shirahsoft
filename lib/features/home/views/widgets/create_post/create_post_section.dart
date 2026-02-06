import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/core/localization/app_string_localizations.dart';

/// Create Post Section - Post creation shortcut with action buttons
/// Displays user profile picture, text input placeholder, and quick action buttons
/// Design: Static section, always visible, no loading animation
class CreatePostSection extends StatelessWidget {
  const CreatePostSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// -- Profile & Input Row
          Row(
            children: [
              /// -- Profile Picture
              Container(
                width: 40.w,
                height: 40.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://picsum.photos/100/100?random=1',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              /// -- Input Placeholder Button
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // TODO: Navigate to create post screen
                  },
                  child: Container(
                    height: 44.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF2A2A3E)
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(22.r),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppStrings.whatsOnMind,
                      style: getTextStyle(
                        fontSize: 16,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.5)
                            : const Color(0xFF6A7282),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 15.h),

          /// -- Divider
          Container(
            height: 1.3.h,
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : const Color(0xFFF3F4F6),
          ),

          SizedBox(height: 17.h),

          /// -- Action Buttons Row (Horizontal Scroll)
          SizedBox(
            height: 51.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                /// Image Button - Green
                _buildActionButton(
                  icon: Iconsax.image,
                  label: 'Image',
                  gradientColors: const [Color(0xFF00C950), Color(0xFF009689)],
                  bgGradientColors: const [
                    Color(0xFFF0FDF4),
                    Color(0xFFF0FDFA),
                  ],
                  borderColor: const Color(0xFFDCFCE7),
                  textColor: const Color(0xFF008236),
                  isDark: isDark,
                  onTap: () {},
                ),
                SizedBox(width: 8.w),

                /// Sell Post Button - Blue
                _buildActionButton(
                  icon: Iconsax.shopping_cart,
                  label: 'Sell Post',
                  gradientColors: const [Color(0xFF2B7FFF), Color(0xFF4F39F6)],
                  bgGradientColors: const [
                    Color(0xFFEFF6FF),
                    Color(0xFFEEF2FF),
                  ],
                  borderColor: const Color(0xFFDBEAFE),
                  textColor: const Color(0xFF1447E6),
                  isDark: isDark,
                  onTap: () {},
                ),
                SizedBox(width: 8.w),

                /// Job Post Button - Purple/Pink
                _buildActionButton(
                  icon: Iconsax.briefcase,
                  label: 'Job Post',
                  gradientColors: const [Color(0xFFAD46FF), Color(0xFFE60076)],
                  bgGradientColors: const [
                    Color(0xFFFAF5FF),
                    Color(0xFFFDF2F8),
                  ],
                  borderColor: const Color(0xFFF3E8FF),
                  textColor: const Color(0xFF8200DB),
                  isDark: isDark,
                  onTap: () {},
                ),
                SizedBox(width: 8.w),

                /// Looking for Button - Orange
                _buildActionButton(
                  icon: Iconsax.bag,
                  label: 'Looking for',
                  gradientColors: const [Color(0xFFFF6900), Color(0xFFE17100)],
                  bgGradientColors: const [
                    Color(0xFFFFF7ED),
                    Color(0xFFFFFBEB),
                  ],
                  borderColor: const Color(0xFFFFEDD4),
                  textColor: const Color(0xFFCA3500),
                  isDark: isDark,
                  onTap: () {},
                ),
                SizedBox(width: 8.w),

                /// Add Product Button - Teal/Green
                _buildActionButton(
                  icon: Iconsax.trend_up,
                  label: 'Add Product',
                  gradientColors: const [Color(0xFF00BC7D), Color(0xFF00A63E)],
                  bgGradientColors: const [
                    Color(0xFFECFDF5),
                    Color(0xFFF0FDF4),
                  ],
                  borderColor: const Color(0xFFD0FAE5),
                  textColor: const Color(0xFF007A55),
                  isDark: isDark,
                  onTap: () {},
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  /// Build single action button with specific colors
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required List<Color> gradientColors,
    required List<Color> bgGradientColors,
    required Color borderColor,
    required Color textColor,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 1.3.h),
        decoration: BoxDecoration(
          gradient: isDark
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: bgGradientColors,
                ),
          color: isDark ? const Color(0xFF2A2A3E) : null,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.1) : borderColor,
            width: 1.3,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// -- Icon Container with Gradient
            Container(
              width: 28.w,
              height: 28.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                ),
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Icon(icon, size: 16.sp, color: Colors.white),
            ),
            SizedBox(width: 8.w),

            /// -- Label
            Text(
              label,
              style: getBoldTextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
