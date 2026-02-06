import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/core/utils/constants/app_style_colors.dart';

/// Activities Tab - Shows notifications and activity feed
class ActivitiesTab extends StatelessWidget {
  const ActivitiesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Activities',
                      style: getK2DTextStyle(
                        fontSize: 24,
                        color: AppStyleColors.instance.primary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Mark all read',
                        style: getTextStyle(
                          fontSize: 12,
                          color: AppStyleColors.instance.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  'Stay updated with your latest notifications',
                  style: getTextStyle(
                    fontSize: 14,
                    color: AppStyleColors.instance.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Filter Tabs
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                _FilterChip(label: 'All', isSelected: true),
                SizedBox(width: 8.w),
                _FilterChip(label: 'Unread', isSelected: false),
                SizedBox(width: 8.w),
                _FilterChip(label: 'Mentions', isSelected: false),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // Notifications List
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              padding: EdgeInsets.all(32.w),
              decoration: BoxDecoration(
                color: AppStyleColors.instance.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppStyleColors.instance.borderFocused.withValues(
                    alpha: 0.2,
                  ),
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      size: 64.w,
                      color: AppStyleColors.instance.textSecondary,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No notifications yet',
                      style: getBoldTextStyle(
                        fontSize: 16,
                        color: AppStyleColors.instance.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'You\'ll see your notifications here',
                      style: getTextStyle(
                        fontSize: 14,
                        color: AppStyleColors.instance.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

/// Filter Chip Widget
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _FilterChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isSelected
            ? AppStyleColors.instance.primary
            : AppStyleColors.instance.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isSelected
              ? AppStyleColors.instance.primary
              : AppStyleColors.instance.borderFocused.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        label,
        style: getTextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isSelected
              ? Colors.white
              : AppStyleColors.instance.textPrimary,
        ),
      ),
    );
  }
}
