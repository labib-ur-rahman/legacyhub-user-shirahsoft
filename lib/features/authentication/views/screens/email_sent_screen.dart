import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:legacyhub/core/common/widgets/buttons/gradient_action_button.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/core/localization/app_string_localizations.dart';
import 'package:legacyhub/core/utils/constants/lottie_path.dart';
import 'package:legacyhub/core/utils/constants/svg_path.dart';
import 'package:legacyhub/core/utils/helpers/svg_icon_helper.dart';
import 'package:legacyhub/features/authentication/controllers/auth_controller.dart';
import 'package:legacyhub/features/authentication/views/widgets/gradient_auth_background.dart';
import 'package:legacyhub/routes/app_routes.dart';
import 'package:lottie/lottie.dart';

/// Check Email Screen — matches Figma design node 803:618
/// Shown after password reset email is sent
class CheckEmailScreen extends StatefulWidget {
  const CheckEmailScreen({super.key});

  @override
  State<CheckEmailScreen> createState() => _CheckEmailScreenState();
}

class _CheckEmailScreenState extends State<CheckEmailScreen> {
  /// Resend cooldown timer
  Timer? _resendTimer;
  int _resendCountdown = 0;

  String get _email => Get.arguments?['email'] as String? ?? '';

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _resendCountdown = 60;
    });
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown <= 1) {
        timer.cancel();
        setState(() {
          _resendCountdown = 0;
        });
      } else {
        setState(() {
          _resendCountdown--;
        });
      }
    });
  }

  void _resendEmail() {
    if (_resendCountdown > 0) return;
    final controller = AuthController.instance;
    controller.forgotPassword(_email);
    _startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: GradientAuthBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 16.h),

                  // Back button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        padding: EdgeInsets.all(7.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(100.r),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: SvgIconHelper.buildIcon(
                          assetPath: SvgPath.arrowLineLeft,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // White card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 50,
                          offset: const Offset(0, 25),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Mail icon (Lottie animation)
                        Transform.translate(
                          offset: Offset(0, -40.h),
                          child: Lottie.asset(
                            LottiePath.emailVerification,
                            height: 260.h,
                            fit: BoxFit.contain,
                          ),
                        ),

                        Column(
                          children: [
                            SizedBox(height: 170.h),

                            // Title
                            Text(
                              AppStrings.authCheckEmailTitle,
                              style: getHeadingStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16.h),

                            // "We've sent a password reset link to:"
                            Text(
                              AppStrings.authCheckEmailSubtitle,
                              style: getTextStyle(
                                fontSize: 14,
                                color: isDark
                                    ? Colors.white70
                                    : const Color(0xFF6C757D),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8.h),

                            // Email address
                            Text(
                              _email,
                              style: getBoldTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF006AED),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16.h),

                            // Instructions
                            Text(
                              AppStrings.authCheckEmailInstructions,
                              style: getTextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? Colors.white70
                                    : const Color(0xFF6C757D),
                                lineHeight: 1.6,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20.h),

                            // Tip box
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.05)
                                    : const Color(0xFFF9FAFB),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.1)
                                      : const Color(0xFFE5E7EB),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Iconsax.info_circle,
                                    size: 18.sp,
                                    color: const Color(0xFF006AED),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppStrings.authTipLabel,
                                          style: getBoldTextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          AppStrings.authCheckEmailTip,
                                          style: getTextStyle(
                                            fontSize: 12,
                                            color: isDark
                                                ? Colors.white70
                                                : const Color(0xFF6C757D),
                                            lineHeight: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24.h),

                            // Back to Login button
                            GradientActionButton(
                              showArrow: false,
                              text: AppStrings.authBackToLogin,
                              onPressed: () => Get.offAllNamed(AppRoutes.LOGIN),
                            ),
                            SizedBox(height: 20.h),

                            // Resend
                            GestureDetector(
                              onTap: _resendCountdown > 0 ? null : _resendEmail,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppStrings.authDidntReceiveEmail,
                                    style: getTextStyle(
                                      fontSize: 14,
                                      color: isDark
                                          ? Colors.white70
                                          : const Color(0xFF6C757D),
                                    ),
                                  ),
                                  Text(
                                    _resendCountdown > 0
                                        ? ' ${_resendCountdown}s'
                                        : AppStrings.authResend,
                                    style: getBoldTextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: _resendCountdown > 0
                                          ? (isDark
                                                ? Colors.white.withValues(
                                                    alpha: 0.5,
                                                  )
                                                : const Color(
                                                    0xFF006AED,
                                                  ).withValues(alpha: 0.5))
                                          : const Color(0xFF006AED),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
