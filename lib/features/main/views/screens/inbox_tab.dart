import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/core/utils/constants/app_style_colors.dart';
import 'package:legacyhub/features/main/controllers/main_header_controller.dart';
import 'package:legacyhub/features/main/views/widgets/profile_picture.dart';

/// Inbox Tab - Messages and conversations screen
/// Displays user's messages with scrollable list
/// Works with collapsible header on scroll
class InboxTab extends StatelessWidget {
  const InboxTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// -- Back Button Row
          _buildBackButton(isDark),

          SizedBox(height: 16.h),

          /// -- Search Bar
          _buildSearchBar(isDark),

          SizedBox(height: 20.h),

          /// -- Message Categories
          _buildCategoryChips(isDark),

          SizedBox(height: 20.h),

          /// -- Messages List
          _buildMessagesList(isDark),
        ],
      ),
    );
  }

  /// Build back button to return to previous tab
  Widget _buildBackButton(bool isDark) {
    return GestureDetector(
      onTap: () => MainHeaderController.instance.hideInbox(),
      child: Row(
        children: [
          Icon(
            Iconsax.arrow_left,
            size: 20.sp,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
          SizedBox(width: 8.w),
          Text(
            'Back',
            style: getTextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  /// Build search bar
  Widget _buildSearchBar(bool isDark) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search messages...',
          hintStyle: getTextStyle(
            fontSize: 14,
            color: isDark ? Colors.white38 : Colors.grey,
          ),
          prefixIcon: Icon(
            Iconsax.search_normal,
            size: 20.sp,
            color: isDark ? Colors.white38 : Colors.grey,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
        ),
        style: getTextStyle(
          fontSize: 14,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  /// Build category filter chips
  Widget _buildCategoryChips(bool isDark) {
    final categories = ['All', 'Unread', 'Support', 'Orders'];

    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final isSelected = index == 0;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? AppStyleColors.instance.appBarGradient
                  : null,
              color: isSelected
                  ? null
                  : (isDark ? Colors.white10 : Colors.grey.shade100),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Text(
              categories[index],
              style: getTextStyle(
                fontSize: 13,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white70 : Colors.black54),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build messages list
  Widget _buildMessagesList(bool isDark) {
    // Demo messages
    final messages = [
      _MessageItem(
        name: 'LegacyHub Support',
        message:
            'Welcome to LegacyHub! Your account has been verified successfully.',
        time: '2m ago',
        isUnread: true,
        avatarUrl: 'https://avatars.githubusercontent.com/u/177158869',
      ),
      _MessageItem(
        name: 'Order #1234',
        message: 'Your order has been shipped and is on its way.',
        time: '15m ago',
        isUnread: true,
        avatarUrl: null,
      ),
      _MessageItem(
        name: 'Wallet Update',
        message: '৳500 has been credited to your wallet.',
        time: '1h ago',
        isUnread: false,
        avatarUrl: null,
      ),
      _MessageItem(
        name: 'Referral Bonus',
        message: 'Congratulations! You earned 50 reward points.',
        time: '3h ago',
        isUnread: false,
        avatarUrl: null,
      ),
      _MessageItem(
        name: 'System Update',
        message: 'New features are now available. Check them out!',
        time: '1d ago',
        isUnread: false,
        avatarUrl: null,
      ),
    ];

    return Column(
      children: messages.map((msg) => _buildMessageTile(msg, isDark)).toList(),
    );
  }

  /// Build individual message tile
  Widget _buildMessageTile(_MessageItem message, bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: message.isUnread
            ? (isDark
                  ? AppStyleColors.instance.primary.withValues(alpha: 0.1)
                  : AppStyleColors.instance.primary.withValues(alpha: 0.05))
            : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// -- Avatar
          message.avatarUrl != null
              ? ProfilePicture(
                  width: 48.w,
                  height: 48.w,
                  imageUrl: message.avatarUrl,
                  showBorder: false,
                )
              : Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    gradient: AppStyleColors.instance.appBarGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.message,
                    size: 20.sp,
                    color: Colors.white,
                  ),
                ),

          SizedBox(width: 12.w),

          /// -- Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// -- Name & Time Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        message.name,
                        style: getBoldTextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      message.time,
                      style: getTextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white38 : Colors.grey,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4.h),

                /// -- Message Preview
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        message.message,
                        style: getTextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white54 : Colors.black54,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (message.isUnread) ...[
                      SizedBox(width: 8.w),
                      Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          color: AppStyleColors.instance.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
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

/// Message item data class
class _MessageItem {
  final String name;
  final String message;
  final String time;
  final bool isUnread;
  final String? avatarUrl;

  _MessageItem({
    required this.name,
    required this.message,
    required this.time,
    required this.isUnread,
    this.avatarUrl,
  });
}
