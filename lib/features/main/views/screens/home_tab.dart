import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/core/utils/constants/app_style_colors.dart';

/// Home Tab - Main dashboard with services and features
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Stats Section
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back!',
                  style: getK2DTextStyle(
                    fontSize: 24,
                    color: AppStyleColors.instance.primary,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    _StatCard(
                      title: 'Active\nOrders',
                      value: '0',
                      icon: Icons.shopping_bag,
                    ),
                    SizedBox(width: 12.w),
                    _StatCard(
                      title: 'Total\nEarnings',
                      value: '0 BDT',
                      icon: Icons.wallet,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Services Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Services',
                  style: getK2DTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12.h),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _ServiceCard(title: 'Recharge', icon: Icons.phone_android),
                    _ServiceCard(title: 'Pay Bills', icon: Icons.receipt),
                    _ServiceCard(title: 'Send Money', icon: Icons.send),
                    _ServiceCard(title: 'More', icon: Icons.more_horiz),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // Featured Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Featured Offers',
                  style: getK2DTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  height: 150.h,
                  decoration: BoxDecoration(
                    gradient: AppStyleColors.instance.appBarGradient,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Text(
                      'Featured Banner',
                      style: getTextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
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

/// Stat Card Widget
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppStyleColors.instance.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppStyleColors.instance.borderFocused.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppStyleColors.instance.primary, size: 24.w),
            SizedBox(height: 8.h),
            Text(
              title,
              style: getTextStyle(
                fontSize: 12,
                color: AppStyleColors.instance.textSecondary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: getBoldTextStyle(
                fontSize: 16,
                color: AppStyleColors.instance.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Service Card Widget
class _ServiceCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const _ServiceCard({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: AppStyleColors.instance.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppStyleColors.instance.borderFocused.withOpacity(0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppStyleColors.instance.primary, size: 32.w),
            SizedBox(height: 8.h),
            Text(
              title,
              style: getBoldTextStyle(
                fontSize: 14,
                color: AppStyleColors.instance.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
