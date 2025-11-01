import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_template/core/localization/app_string_localizations.dart';
import 'package:project_template/core/utils/constants/colors.dart';

/// Modern payment failure screen with retry options
class PaymentFailureScreen extends StatelessWidget {
  final String reason;
  final bool isUserCancelled;

  const PaymentFailureScreen({
    super.key,
    required this.reason,
    this.isUserCancelled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Failure Icon
                    Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isUserCancelled
                            ? Colors.orange.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                      ),
                      child: Icon(
                        isUserCancelled
                            ? Icons.info_outline
                            : Icons.error_outline,
                        color: isUserCancelled ? Colors.orange : Colors.red,
                        size: 80.w,
                      ),
                    ),

                    32.verticalSpace,

                    // Title
                    Text(
                      isUserCancelled
                          ? AppStrings.paymentCancelled
                          : AppStrings.paymentFailed,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.center,
                    ),

                    16.verticalSpace,

                    // Message
                    Text(
                      isUserCancelled
                          ? AppStrings.paymentCancelledMessage
                          : AppStrings.paymentFailedMessage,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    if (!isUserCancelled) ...[
                      24.verticalSpace,

                      // Error Details Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Colors.red.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.errorDetails,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.red[700],
                              ),
                            ),
                            8.verticalSpace,
                            Text(
                              reason,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.red[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    32.verticalSpace,

                    // Help Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.withValues(alpha: 0.05),
                            Colors.indigo.withValues(alpha: 0.02),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: Colors.blue.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.help_outline,
                            color: Colors.blue,
                            size: 32.w,
                          ),
                          12.verticalSpace,
                          Text(
                            AppStrings.needHelp,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          8.verticalSpace,
                          Text(
                            AppStrings.contactSupportMessage,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Action Buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Go back and retry payment
                        Get.back();
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        AppStrings.tryAgain,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
