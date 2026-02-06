import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/core/utils/constants/app_style_colors.dart';

/// Wallet Tab - Wallet balance and transaction history
class WalletTab extends StatelessWidget {
  const WalletTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wallet Balance Cards
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wallet',
                  style: getK2DTextStyle(
                    fontSize: 24,
                    color: AppStyleColors.instance.primary,
                  ),
                ),
                SizedBox(height: 16.h),

                // Main Wallet Balance Card
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    gradient: AppStyleColors.instance.appBarGradient,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Balance',
                        style: getTextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '৳ 0.00',
                        style: getK2DTextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: _WalletActionButton(
                              title: 'Send',
                              icon: Icons.send,
                              onTap: () {},
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _WalletActionButton(
                              title: 'Receive',
                              icon: Icons.call_received,
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // Reward Points Card
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppStyleColors.instance.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppStyleColors.instance.secondary.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: AppStyleColors.instance.secondary,
                        size: 32.w,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reward Points',
                              style: getTextStyle(
                                fontSize: 14,
                                color: AppStyleColors.instance.textSecondary,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '0 Points',
                              style: getBoldTextStyle(
                                fontSize: 18,
                                color: AppStyleColors.instance.secondary,
                              ),
                            ),
                          ],
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
              ],
            ),
          ),

          // Transaction History
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Transactions',
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
                    child: Text(
                      'No transactions yet',
                      style: getTextStyle(
                        fontSize: 14,
                        color: AppStyleColors.instance.textSecondary,
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

/// Wallet Action Button Widget
class _WalletActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _WalletActionButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18.w),
            SizedBox(width: 6.w),
            Text(
              title,
              style: getTextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
