import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/core/utils/constants/app_style_colors.dart';

/// Sell Item Post Card - User selling an item
/// Shows: User avatar, name, item images, price, condition, location
class SellItemPostCard extends StatelessWidget {
  const SellItemPostCard({
    super.key,
    required this.userName,
    required this.userAvatar,
    required this.timeAgo,
    required this.itemTitle,
    required this.description,
    required this.price,
    required this.condition,
    required this.location,
    required this.images,
    this.isNegotiable = false,
  });

  final String userName;
  final String userAvatar;
  final String timeAgo;
  final String itemTitle;
  final String description;
  final String price;
  final String condition;
  final String location;
  final List<String> images;
  final bool isNegotiable;

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
                    color: Colors.teal.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: Colors.teal.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Iconsax.bag, size: 14.sp, color: Colors.teal),
                      SizedBox(width: 6.w),
                      Text(
                        'For Sale',
                        style: getBoldTextStyle(
                          fontSize: 12,
                          color: Colors.teal,
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
                      Row(
                        children: [
                          Text(
                            timeAgo,
                            style: getTextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white54 : Colors.grey,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Icon(
                            Iconsax.location,
                            size: 12.sp,
                            color: isDark ? Colors.white54 : Colors.grey,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              location,
                              style: getTextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white54 : Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          /// -- Item Images
          if (images.isNotEmpty)
            SizedBox(
              height: 200.h,
              child: images.length == 1
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: CachedNetworkImage(
                          imageUrl: images.first,
                          width: double.infinity,
                          height: 200.h,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: isDark
                                ? const Color(0xFF2A2A3E)
                                : Colors.grey.shade200,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colors.primary,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: isDark
                                ? const Color(0xFF2A2A3E)
                                : Colors.grey.shade200,
                            child: Icon(
                              Iconsax.image,
                              size: 40.sp,
                              color: isDark ? Colors.white38 : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      physics: const BouncingScrollPhysics(),
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: CachedNetworkImage(
                              imageUrl: images[index],
                              width: 180.w,
                              height: 200.h,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 180.w,
                                height: 200.h,
                                color: isDark
                                    ? const Color(0xFF2A2A3E)
                                    : Colors.grey.shade200,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colors.primary,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 180.w,
                                height: 200.h,
                                color: isDark
                                    ? const Color(0xFF2A2A3E)
                                    : Colors.grey.shade200,
                                child: Icon(
                                  Iconsax.image,
                                  size: 40.sp,
                                  color: isDark ? Colors.white38 : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),

          SizedBox(height: 16.h),

          /// -- Item Title & Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemTitle,
                  style: getBoldTextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Text(
                  description,
                  style: getTextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          /// -- Price & Condition Row
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A3E) : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                /// -- Price
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 36.w,
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: Colors.teal.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Iconsax.tag,
                          size: 18.sp,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price',
                            style: getTextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.white54 : Colors.grey,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                price,
                                style: getBoldTextStyle(
                                  fontSize: 16,
                                  color: Colors.teal,
                                ),
                              ),
                              // if (isNegotiable) ...[
                              //   SizedBox(width: 4.w),
                              //   Text(
                              //     '(Negotiable)',
                              //     style: getTextStyle(
                              //       fontSize: 10,
                              //       color: isDark
                              //           ? Colors.white54
                              //           : Colors.grey,
                              //     ),
                              //   ),
                              // ],
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// -- Divider
                Container(
                  width: 1,
                  height: 36.h,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.3),
                ),
                SizedBox(width: 16.w),

                /// -- Condition
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 36.w,
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Iconsax.box_1,
                          size: 18.sp,
                          color: Colors.amber.shade700,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Condition',
                            style: getTextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.white54 : Colors.grey,
                            ),
                          ),
                          Text(
                            condition,
                            style: getBoldTextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          /// -- Footer: Action Buttons
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                /// -- Save Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.primary,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: BorderSide(color: colors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.heart, size: 18.sp, color: colors.primary),
                        SizedBox(width: 6.w),
                        Text(
                          'Save',
                          style: getBoldTextStyle(
                            fontSize: 13,
                            color: colors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                /// -- Message Button
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.message, size: 18.sp, color: Colors.white),
                        SizedBox(width: 6.w),
                        Text(
                          'Message Seller',
                          style: getBoldTextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ],
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
