import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/core/utils/constants/app_style_colors.dart';

/// Profile Tab - User profile and settings
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  /// Default profile image URL
  static const String defaultProfileUrl =
      'https://avatars.githubusercontent.com/u/177158869';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20.h),

          // Profile Picture
          Center(
            child: Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppStyleColors.instance.primary,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppStyleColors.instance.primary.withValues(
                      alpha: 0.3,
                    ),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: defaultProfileUrl,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[400],
                    child: Icon(Icons.person, color: Colors.white, size: 48.w),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // User Name
          Text(
            'User Name',
            style: getK2DTextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppStyleColors.instance.textPrimary,
            ),
          ),

          SizedBox(height: 4.h),

          // User Email/Phone
          Text(
            '+880 1XXX-XXXXXX',
            style: getTextStyle(
              fontSize: 14,
              color: AppStyleColors.instance.textSecondary,
            ),
          ),

          SizedBox(height: 8.h),

          // Invite Code Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              gradient: AppStyleColors.instance.appBarGradient,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: Colors.white, size: 16.w),
                SizedBox(width: 6.w),
                Text(
                  'SA7K9Q2L',
                  style: getK2DTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // Stats Row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ProfileStat(label: 'Projects', value: '0'),
                _ProfileDivider(),
                _ProfileStat(label: 'Earnings', value: '৳0'),
                _ProfileDivider(),
                _ProfileStat(label: 'Points', value: '0'),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // Menu Items
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                _ProfileMenuItem(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  onTap: () {},
                ),
                _ProfileMenuItem(
                  icon: Icons.wallet_outlined,
                  title: 'My Wallet',
                  onTap: () {},
                ),
                _ProfileMenuItem(
                  icon: Icons.history,
                  title: 'Transaction History',
                  onTap: () {},
                ),
                _ProfileMenuItem(
                  icon: Icons.people_outline,
                  title: 'My Network',
                  onTap: () {},
                ),
                _ProfileMenuItem(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {},
                ),
                _ProfileMenuItem(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () {},
                ),
                _ProfileMenuItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {},
                  isDestructive: true,
                ),
              ],
            ),
          ),

          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}

/// Profile Stat Widget
class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
          label,
          style: getTextStyle(
            fontSize: 12,
            color: AppStyleColors.instance.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Profile Divider Widget
class _ProfileDivider extends StatelessWidget {
  const _ProfileDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      width: 1,
      color: AppStyleColors.instance.borderFocused.withValues(alpha: 0.3),
    );
  }
}

/// Profile Menu Item Widget
class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: AppStyleColors.instance.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppStyleColors.instance.borderFocused.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive
                  ? AppStyleColors.instance.error
                  : AppStyleColors.instance.primary,
              size: 24.w,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDestructive
                      ? AppStyleColors.instance.error
                      : AppStyleColors.instance.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppStyleColors.instance.textSecondary,
              size: 16.w,
            ),
          ],
        ),
      ),
    );
  }
}
