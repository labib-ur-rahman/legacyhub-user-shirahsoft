import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/core/utils/constants/app_style_colors.dart';

/// Network Tab - Community and network connections
class NetworkTab extends StatelessWidget {
  const NetworkTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Network Header
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Network',
                  style: getK2DTextStyle(
                    fontSize: 24,
                    color: AppStyleColors.instance.primary,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Connect with others in your network',
                  style: getTextStyle(
                    fontSize: 14,
                    color: AppStyleColors.instance.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Network Stats
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  child: _NetworkStatCard(
                    title: 'Direct\nConnections',
                    value: '0',
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _NetworkStatCard(title: 'Total\nNetwork', value: '0'),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // Invite Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Invite Friends',
                  style: getK2DTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    gradient: AppStyleColors.instance.appBarGradient,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Invite Code',
                        style: getTextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'SA7K9Q2L',
                              style: getK2DTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Icon(
                                Icons.copy,
                                color: Colors.white,
                                size: 18.w,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: Text(
                                'Share',
                                style: getTextStyle(
                                  fontSize: 12,
                                  color: AppStyleColors.instance.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
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

          SizedBox(height: 20.h),

          // Connections List
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Connections',
                  style: getK2DTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppStyleColors.instance.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppStyleColors.instance.borderFocused.withOpacity(
                        0.2,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.people_outline,
                          color: AppStyleColors.instance.textSecondary,
                          size: 48.w,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'No connections yet',
                          style: getTextStyle(
                            fontSize: 14,
                            color: AppStyleColors.instance.textSecondary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Start building your network',
                          style: getTextStyle(
                            fontSize: 12,
                            color: AppStyleColors.instance.textSecondary
                                .withOpacity(0.7),
                          ),
                        ),
                      ],
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

/// Network Stat Card Widget
class _NetworkStatCard extends StatelessWidget {
  final String title;
  final String value;

  const _NetworkStatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
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
          Text(
            title,
            style: getTextStyle(
              fontSize: 12,
              color: AppStyleColors.instance.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: getK2DTextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppStyleColors.instance.primary,
            ),
          ),
        ],
      ),
    );
  }
}
