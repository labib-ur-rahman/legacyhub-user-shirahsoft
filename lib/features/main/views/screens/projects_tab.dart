import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/core/utils/constants/app_style_colors.dart';

/// Projects Tab - Shows user's projects and tasks
class ProjectsTab extends StatelessWidget {
  const ProjectsTab({super.key});

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
                Text(
                  'My Projects',
                  style: getK2DTextStyle(
                    fontSize: 24,
                    color: AppStyleColors.instance.primary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Track and manage your ongoing projects',
                  style: getTextStyle(
                    fontSize: 14,
                    color: AppStyleColors.instance.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Quick Stats
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                _StatCard(
                  title: 'Active',
                  value: '0',
                  icon: Icons.play_circle_outline,
                ),
                SizedBox(width: 12.w),
                _StatCard(
                  title: 'Completed',
                  value: '0',
                  icon: Icons.check_circle_outline,
                ),
                SizedBox(width: 12.w),
                _StatCard(
                  title: 'Pending',
                  value: '0',
                  icon: Icons.pending_outlined,
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // Projects List
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Projects',
                      style: getK2DTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'View All',
                        style: getTextStyle(
                          fontSize: 12,
                          color: AppStyleColors.instance.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Empty State
                Container(
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
                          Icons.folder_open_outlined,
                          size: 64.w,
                          color: AppStyleColors.instance.textSecondary,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No projects yet',
                          style: getBoldTextStyle(
                            fontSize: 16,
                            color: AppStyleColors.instance.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Start a new project to see it here',
                          style: getTextStyle(
                            fontSize: 14,
                            color: AppStyleColors.instance.textSecondary,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.add),
                          label: const Text('Create Project'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppStyleColors.instance.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
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
            color: AppStyleColors.instance.borderFocused.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: AppStyleColors.instance.primary, size: 24.w),
            SizedBox(height: 8.h),
            Text(
              value,
              style: getK2DTextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppStyleColors.instance.primary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: getTextStyle(
                fontSize: 12,
                color: AppStyleColors.instance.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
