import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/core/utils/constants/app_style_colors.dart';

/// Shop Tab - Marketplace and product listing
class ShopTab extends StatelessWidget {
  const ShopTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shop',
                  style: getK2DTextStyle(
                    fontSize: 24,
                    color: AppStyleColors.instance.primary,
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  decoration: BoxDecoration(
                    color: AppStyleColors.instance.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppStyleColors.instance.borderFocused.withValues(
                        alpha: 0.2,
                      ),
                    ),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppStyleColors.instance.textSecondary,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Categories
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categories',
                  style: getK2DTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  height: 100.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: _CategoryCard(
                          title: [
                            'Electronics',
                            'Fashion',
                            'Home',
                            'Books',
                            'Sports',
                          ][index],
                          icon: [
                            Icons.devices,
                            Icons.shopping_bag,
                            Icons.home,
                            Icons.book,
                            Icons.sports_soccer,
                          ][index],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // Products
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Featured Products',
                      style: getK2DTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'View All',
                      style: getTextStyle(
                        fontSize: 12,
                        color: AppStyleColors.instance.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 0.75,
                  children: List.generate(
                    4,
                    (index) => _ProductCard(
                      title: 'Product ${index + 1}',
                      price: '৳ ${(index + 1) * 500}',
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

/// Category Card Widget
class _CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const _CategoryCard({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      decoration: BoxDecoration(
        color: AppStyleColors.instance.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppStyleColors.instance.borderFocused.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppStyleColors.instance.primary, size: 32.w),
          SizedBox(height: 8.h),
          Text(
            title,
            style: getTextStyle(
              fontSize: 12,
              color: AppStyleColors.instance.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Product Card Widget
class _ProductCard extends StatelessWidget {
  final String title;
  final String price;

  const _ProductCard({required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppStyleColors.instance.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppStyleColors.instance.borderFocused.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image Placeholder
          Container(
            height: 120.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppStyleColors.instance.primary.withValues(alpha: 0.2),
                  AppStyleColors.instance.secondary.withValues(alpha: 0.2),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.image,
                color: AppStyleColors.instance.primary,
                size: 48.w,
              ),
            ),
          ),

          // Product Info
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getBoldTextStyle(
                    fontSize: 14,
                    color: AppStyleColors.instance.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: getBoldTextStyle(
                        fontSize: 14,
                        color: AppStyleColors.instance.primary,
                      ),
                    ),
                    Icon(
                      Icons.favorite_border,
                      color: AppStyleColors.instance.textSecondary,
                      size: 18.w,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
