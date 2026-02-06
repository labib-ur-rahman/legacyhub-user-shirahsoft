import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/core/utils/constants/app_style_colors.dart';

/// On-Demand Post Card - User looking for a service/product
/// Shows: User avatar, name, request description, category, budget, location
class OnDemandPostCard extends StatelessWidget {
  const OnDemandPostCard({
    super.key,
    required this.userName,
    required this.userAvatar,
    required this.timeAgo,
    required this.requestTitle,
    required this.description,
    required this.category,
    required this.budget,
    required this.location,
    this.responseCount = 0,
  });

  final String userName;
  final String userAvatar;
  final String timeAgo;
  final String requestTitle;
  final String description;
  final String category;
  final String budget;
  final String location;
  final int responseCount;

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final colors = AppStyleColors.instance;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// -- Header with Type Badge
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                /// -- Type Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: Colors.blue.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Iconsax.search_normal,
                        size: 14.sp,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Looking For',
                        style: getBoldTextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                /// -- More Button
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Iconsax.more,
                    size: 20.sp,
                    color: isDark ? Colors.white54 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          /// -- User Info
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                /// -- Avatar
                CachedNetworkImage(
                  imageUrl: userAvatar,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? const Color(0xFF2A2A3E)
                          : Colors.grey.shade200,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? const Color(0xFF2A2A3E)
                          : Colors.grey.shade200,
                    ),
                    child: Icon(
                      Iconsax.user,
                      size: 20.sp,
                      color: isDark ? Colors.white38 : Colors.grey,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                /// -- Name & Time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: getBoldTextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        timeAgo,
                        style: getTextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white54 : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          /// -- Request Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              requestTitle,
              style: getBoldTextStyle(
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          SizedBox(height: 8.h),

          /// -- Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              description,
              style: getTextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          SizedBox(height: 16.h),

          /// -- Details Row (Category, Budget, Location)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A3E) : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                /// -- Category
                _buildDetailItem(
                  icon: Iconsax.category,
                  label: 'Category',
                  value: category,
                  iconColor: Colors.purple,
                  isDark: isDark,
                ),

                /// -- Divider
                Container(
                  width: 1,
                  height: 36.h,
                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.3),
                ),

                /// -- Budget
                _buildDetailItem(
                  icon: Iconsax.money,
                  label: 'Budget',
                  value: budget,
                  iconColor: Colors.green,
                  isDark: isDark,
                ),

                /// -- Divider
                Container(
                  width: 1,
                  height: 36.h,
                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.3),
                ),

                /// -- Location
                _buildDetailItem(
                  icon: Iconsax.location,
                  label: 'Location',
                  value: location,
                  iconColor: Colors.red,
                  isDark: isDark,
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          /// -- Footer: Response Count & Action Button
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                /// -- Response Count
                Row(
                  children: [
                    Icon(
                      Iconsax.message,
                      size: 18.sp,
                      color: isDark ? Colors.white54 : Colors.grey,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '$responseCount responses',
                      style: getTextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white54 : Colors.grey,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                /// -- Offer Button
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 10.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Iconsax.send_1, size: 16.sp, color: Colors.white),
                      SizedBox(width: 6.w),
                      Text(
                        'Make Offer',
                        style: getBoldTextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build detail item
  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    required bool isDark,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 18.sp, color: iconColor),
          SizedBox(height: 4.h),
          Text(
            value,
            style: getBoldTextStyle(
              fontSize: 12,
              color: isDark ? Colors.white : Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
