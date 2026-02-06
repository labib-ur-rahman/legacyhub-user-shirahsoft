import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/core/utils/constants/app_style_colors.dart';

/// People You May Know Section - Horizontal scroll list of suggested users
/// Shows: User cards with avatar, name, mutual friends count, and add button
class PeopleYouMayKnowSection extends StatelessWidget {
  const PeopleYouMayKnowSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final colors = AppStyleColors.instance;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.all(16.w),
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
          /// -- Section Header
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  gradient: colors.appBarGradient,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Iconsax.people, size: 20.sp, color: Colors.white),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'People You May Know',
                      style: getBoldTextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      'Expand your network',
                      style: getTextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white54 : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: getBoldTextStyle(fontSize: 14, color: colors.primary),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          /// -- People Horizontal List
          SizedBox(
            height: 200.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildPersonCard(
                  name: 'John Doe',
                  avatar: 'https://picsum.photos/100/100?random=20',
                  mutualCount: 5,
                  isDark: isDark,
                  colors: colors,
                ),
                SizedBox(width: 12.w),
                _buildPersonCard(
                  name: 'Sarah Ahmed',
                  avatar: 'https://picsum.photos/100/100?random=21',
                  mutualCount: 12,
                  isDark: isDark,
                  colors: colors,
                ),
                SizedBox(width: 12.w),
                _buildPersonCard(
                  name: 'Rahim Khan',
                  avatar: 'https://picsum.photos/100/100?random=22',
                  mutualCount: 3,
                  isDark: isDark,
                  colors: colors,
                ),
                SizedBox(width: 12.w),
                _buildPersonCard(
                  name: 'Fatima Begum',
                  avatar: 'https://picsum.photos/100/100?random=23',
                  mutualCount: 8,
                  isDark: isDark,
                  colors: colors,
                ),
                SizedBox(width: 12.w),
                _buildPersonCard(
                  name: 'Karim Ali',
                  avatar: 'https://picsum.photos/100/100?random=24',
                  mutualCount: 15,
                  isDark: isDark,
                  colors: colors,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build single person card
  Widget _buildPersonCard({
    required String name,
    required String avatar,
    required int mutualCount,
    required bool isDark,
    required AppStyleColors colors,
  }) {
    return Container(
      width: 130.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A3E) : const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// -- Close Button
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {},
              child: Icon(
                Iconsax.close_circle,
                size: 18.sp,
                color: isDark ? Colors.white38 : Colors.grey.shade400,
              ),
            ),
          ),

          /// -- Avatar
          CachedNetworkImage(
            imageUrl: avatar,
            imageBuilder: (context, imageProvider) => Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.3),
                  width: 2,
                ),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? const Color(0xFF3A3A4E) : Colors.grey.shade300,
              ),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.primary,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? const Color(0xFF3A3A4E) : Colors.grey.shade300,
              ),
              child: Icon(
                Iconsax.user,
                size: 28.sp,
                color: isDark ? Colors.white38 : Colors.grey,
              ),
            ),
          ),

          SizedBox(height: 10.h),

          /// -- Name
          Text(
            name,
            style: getBoldTextStyle(
              fontSize: 13,
              color: isDark ? Colors.white : Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 4.h),

          /// -- Mutual Friends Count
          Text(
            '$mutualCount mutual',
            style: getTextStyle(
              fontSize: 11,
              color: isDark ? Colors.white54 : Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 10.h),

          /// -- Add Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.user_add, size: 14.sp, color: Colors.white),
                  SizedBox(width: 4.w),
                  Text(
                    'Add',
                    style: getBoldTextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
