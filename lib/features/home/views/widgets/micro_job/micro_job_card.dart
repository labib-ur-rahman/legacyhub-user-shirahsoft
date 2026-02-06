import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';

/// Micro Job Card - Figma design implementation
/// Shows: Green badge, title, description, image, task link button, stats, complete button
/// Design matches Figma: Clean card with proper hierarchy and responsive layout
class MicroJobCard extends StatelessWidget {
  const MicroJobCard({
    super.key,
    required this.jobTitle,
    required this.description,
    this.imageUrl,
    this.taskLink,
    this.perTaskAmount = '1\$',
    this.completedTasks = 230,
    this.totalTasks = 500,
    this.onTaskLinkPressed,
    this.onCompletePressed,
  });

  final String jobTitle;
  final String description;
  final String? imageUrl;
  final String? taskLink;
  final String perTaskAmount;
  final int completedTasks;
  final int totalTasks;
  final VoidCallback? onTaskLinkPressed;
  final VoidCallback? onCompletePressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          /// -- Left Border Accent (Green vertical line)
          Container(
            width: 4.w,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                bottomLeft: Radius.circular(16.r),
              ),
            ),
          ),

          /// -- Main Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// -- Header with Green Badge and Title in same line
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      /// -- Green Circle Icon
                      Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Iconsax.briefcase,
                          size: 16.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8.w),

                      /// -- Title and MICRO JOB in one column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              jobTitle,
                              style: getBoldTextStyle(
                                fontSize: 15,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF111827),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '• MICRO JOB',
                              style: getTextStyle(
                                fontSize: 11,
                                color: const Color(0xFF10B981),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// -- All Badge (from Figma)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'All',
                              style: getBoldTextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Icon(
                              Iconsax.arrow_right_2,
                              size: 8.sp,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /// -- Description
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    description,
                    style: getTextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white60 : const Color(0xFF6B7280),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                SizedBox(height: 12.h),

                /// -- Image (if provided)
                if (imageUrl != null)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl!,
                        width: double.infinity,
                        height: 200.h,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: double.infinity,
                          height: 200.h,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF2A2A3E)
                                : const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: isDark ? Colors.white38 : Colors.grey,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: double.infinity,
                          height: 200.h,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF2A2A3E)
                                : const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Iconsax.image,
                            size: 40.sp,
                            color: isDark ? Colors.white38 : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),

                SizedBox(height: 16.h),

                /// -- Open Task Link Button (Blue to Purple Gradient)
                if (taskLink != null)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    width: double.infinity,
                    height: 44.h,
                    child: ElevatedButton(
                      onPressed: onTaskLinkPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF3B82F6), // Blue-500
                              Color(0xFF8B5CF6), // Purple-500
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Iconsax.link_21,
                                size: 14.sp,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Open Task Link',
                                style: getBoldTextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Icon(
                                Iconsax.arrow_right_2,
                                size: 14.sp,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                SizedBox(height: 16.h),

                /// -- Stats Row (Per task & Remaining)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      /// -- Per Task (Green background)
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7), // Light green
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Per task',
                                style: getTextStyle(
                                  fontSize: 11,
                                  color: const Color(0xFF065F46),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                perTaskAmount,
                                style: getBoldTextStyle(
                                  fontSize: 18,
                                  color: const Color(0xFF059669),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),

                      /// -- Remaining (Orange background)
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFED7AA), // Light orange
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Remaining',
                                style: getTextStyle(
                                  fontSize: 11,
                                  color: const Color(0xFF9A3412),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '$completedTasks',
                                      style: getBoldTextStyle(
                                        fontSize: 18,
                                        color: const Color(0xFFEA580C),
                                      ),
                                    ),
                                    TextSpan(
                                      text: '/$totalTasks',
                                      style: getBoldTextStyle(
                                        fontSize: 18,
                                        color: const Color(0xFFEA580C),
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ⏱',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: const Color(0xFFEA580C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                /// -- Complete and Earn Button (Green Gradient)
                Container(
                  margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                  width: double.infinity,
                  height: 44.h,
                  child: ElevatedButton(
                    onPressed: onCompletePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF10B981), // Green-500
                            Color(0xFF059669), // Green-600
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Complete and Earn',
                              style: getBoldTextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(
                              Iconsax.arrow_right_2,
                              size: 14.sp,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
