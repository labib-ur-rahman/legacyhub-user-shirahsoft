import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/core/localization/app_string_localizations.dart';
import 'package:legacyhub/core/utils/constants/app_style_colors.dart';

/// Resell Product Card - Displays a product available for reselling
/// Shows: Product image, title, reseller price, profit margin, seller info
class ResellProductCard extends StatelessWidget {
  const ResellProductCard({
    super.key,
    required this.productTitle,
    required this.productImage,
    required this.originalPrice,
    required this.resellerPrice,
    required this.profit,
    required this.sellerName,
    required this.sellerAvatar,
    this.rating = 4.5,
    this.soldCount = 0,
    this.isFeatured = false,
  });

  final String productTitle;
  final String productImage;
  final String originalPrice;
  final String resellerPrice;
  final String profit;
  final String sellerName;
  final String sellerAvatar;
  final double rating;
  final int soldCount;
  final bool isFeatured;

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
          /// -- Header with Type Badge & Featured
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
                    gradient: colors.appBarGradient,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Iconsax.shop, size: 14.sp, color: Colors.white),
                      SizedBox(width: 6.w),
                      Text(
                        AppStrings.reselling,
                        style: getBoldTextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (isFeatured)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.amber.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Iconsax.star1, size: 12.sp, color: Colors.amber),
                        SizedBox(width: 4.w),
                        Text(
                          'Featured',
                          style: getBoldTextStyle(
                            fontSize: 11,
                            color: Colors.amber.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          /// -- Product Image
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CachedNetworkImage(
                imageUrl: productImage,
                width: double.infinity,
                height: 200.h,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: double.infinity,
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
                  width: double.infinity,
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
          ),

          SizedBox(height: 16.h),

          /// -- Product Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              productTitle,
              style: getBoldTextStyle(
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          SizedBox(height: 12.h),

          /// -- Pricing Row
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A3E) : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                /// -- Reseller Price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reseller Price',
                        style: getTextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white54 : Colors.grey,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        resellerPrice,
                        style: getBoldTextStyle(
                          fontSize: 18,
                          color: colors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                /// -- Divider
                Container(
                  width: 1,
                  height: 40.h,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.3),
                ),
                SizedBox(width: 16.w),

                /// -- Original Price (Strikethrough)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MRP',
                        style: getTextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white54 : Colors.grey,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        originalPrice,
                        style: getTextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white38 : Colors.grey,
                          // decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ),

                /// -- Divider
                Container(
                  width: 1,
                  height: 40.h,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.3),
                ),
                SizedBox(width: 16.w),

                /// -- Profit
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Profit',
                        style: getTextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white54 : Colors.grey,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        profit,
                        style: getBoldTextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          /// -- Rating & Sold Count Row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                /// -- Rating
                Row(
                  children: [
                    Icon(Iconsax.star1, size: 16.sp, color: Colors.amber),
                    SizedBox(width: 4.w),
                    Text(
                      rating.toString(),
                      style: getBoldTextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 16.w),

                /// -- Sold Count
                Text(
                  '$soldCount sold',
                  style: getTextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white54 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          /// -- Footer: Seller Info & Action Buttons
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                /// -- Seller Avatar
                CachedNetworkImage(
                  imageUrl: sellerAvatar,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? const Color(0xFF2A2A3E)
                          : Colors.grey.shade200,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? const Color(0xFF2A2A3E)
                          : Colors.grey.shade200,
                    ),
                    child: Icon(
                      Iconsax.user,
                      size: 18.sp,
                      color: isDark ? Colors.white38 : Colors.grey,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),

                /// -- Seller Name
                Expanded(
                  child: Text(
                    sellerName,
                    style: getBoldTextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),

                /// -- Share Button
                IconButton(
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    backgroundColor: isDark
                        ? const Color(0xFF2A2A3E)
                        : const Color(0xFFF5F5F5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  icon: Icon(
                    Iconsax.share,
                    size: 18.sp,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                ),
                SizedBox(width: 8.w),

                /// -- Resell Button
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
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
                  child: Text(
                    'Resell Now',
                    style: getBoldTextStyle(fontSize: 13, color: Colors.white),
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
