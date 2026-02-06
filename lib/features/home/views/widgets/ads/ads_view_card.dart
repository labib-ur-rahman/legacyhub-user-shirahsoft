import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/core/utils/constants/app_style_colors.dart';

/// Ads View Card - Sponsored advertisement card
/// Shows: Ad image, sponsor name, CTA button
class AdsViewCard extends StatelessWidget {
  const AdsViewCard({
    super.key,
    required this.sponsorName,
    required this.sponsorLogo,
    required this.adImage,
    required this.adTitle,
    required this.adDescription,
    required this.ctaText,
    this.ctaUrl = '',
  });

  final String sponsorName;
  final String sponsorLogo;
  final String adImage;
  final String adTitle;
  final String adDescription;
  final String ctaText;
  final String ctaUrl;

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
          /// -- Header: Sponsor Info & Sponsored Badge
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                /// -- Sponsor Logo
                CachedNetworkImage(
                  imageUrl: sponsorLogo,
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
                      Iconsax.building,
                      size: 20.sp,
                      color: isDark ? Colors.white38 : Colors.grey,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                /// -- Sponsor Name & Sponsored Label
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sponsorName,
                        style: getBoldTextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              'Sponsored',
                              style: getTextStyle(
                                fontSize: 10,
                                color: Colors.amber.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

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

          /// -- Ad Image
          ClipRRect(
            child: CachedNetworkImage(
              imageUrl: adImage,
              width: double.infinity,
              height: 200.h,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: double.infinity,
                height: 200.h,
                color: isDark ? const Color(0xFF2A2A3E) : Colors.grey.shade200,
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
                color: isDark ? const Color(0xFF2A2A3E) : Colors.grey.shade200,
                child: Icon(
                  Iconsax.image,
                  size: 40.sp,
                  color: isDark ? Colors.white38 : Colors.grey,
                ),
              ),
            ),
          ),

          /// -- Ad Title & Description
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  adTitle,
                  style: getBoldTextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Text(
                  adDescription,
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

          /// -- CTA Button
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ctaText,
                      style: getBoldTextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Iconsax.arrow_right_3,
                      size: 18.sp,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
