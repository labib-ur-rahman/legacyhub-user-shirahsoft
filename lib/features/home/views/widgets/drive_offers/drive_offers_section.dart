import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/core/utils/constants/app_style_colors.dart';

/// Drive Offers Section - Horizontal scroll list of telecom/drive offers
/// Shows: Offer cards with images, titles, and validity
class DriveOffersSection extends StatelessWidget {
  const DriveOffersSection({super.key});

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
                child: Icon(Iconsax.mobile, size: 20.sp, color: Colors.white),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Drive Offers',
                      style: getBoldTextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      'Best telecom deals for you',
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

          /// -- Offers Horizontal List
          SizedBox(
            height: 160.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildOfferCard(
                  title: '2GB + 50 Min',
                  price: '৳99',
                  validity: '7 Days',
                  operatorLogo: 'https://picsum.photos/50/50?random=10',
                  bgColor: const Color(0xFFE53935),
                  isDark: isDark,
                ),
                SizedBox(width: 12.w),
                _buildOfferCard(
                  title: '5GB Unlimited',
                  price: '৳199',
                  validity: '30 Days',
                  operatorLogo: 'https://picsum.photos/50/50?random=11',
                  bgColor: const Color(0xFF43A047),
                  isDark: isDark,
                ),
                SizedBox(width: 12.w),
                _buildOfferCard(
                  title: '1GB + 100 SMS',
                  price: '৳49',
                  validity: '3 Days',
                  operatorLogo: 'https://picsum.photos/50/50?random=12',
                  bgColor: const Color(0xFF1E88E5),
                  isDark: isDark,
                ),
                SizedBox(width: 12.w),
                _buildOfferCard(
                  title: '10GB Night',
                  price: '৳149',
                  validity: '15 Days',
                  operatorLogo: 'https://picsum.photos/50/50?random=13',
                  bgColor: const Color(0xFF8E24AA),
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build single offer card
  Widget _buildOfferCard({
    required String title,
    required String price,
    required String validity,
    required String operatorLogo,
    required Color bgColor,
    required bool isDark,
  }) {
    return Container(
      width: 140.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [bgColor, bgColor.withValues(alpha: 0.7)],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: bgColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// -- Operator Logo
          CachedNetworkImage(
            imageUrl: operatorLogo,
            imageBuilder: (context, imageProvider) => Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Iconsax.mobile, size: 16.sp, color: Colors.white),
            ),
          ),

          const Spacer(),

          /// -- Offer Title
          Text(
            title,
            style: getBoldTextStyle(fontSize: 14, color: Colors.white),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 8.h),

          /// -- Price & Validity
          Row(
            children: [
              Text(
                price,
                style: getBoldTextStyle(fontSize: 18, color: Colors.white),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  validity,
                  style: getTextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
