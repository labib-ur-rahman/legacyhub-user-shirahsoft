import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:legacyhub/core/common/widgets/buttons/gradient_action_button.dart';
import 'package:legacyhub/core/common/widgets/text_fields/app_text_field.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/core/localization/app_string_localizations.dart';
import 'package:legacyhub/core/utils/constants/lottie_path.dart';
import 'package:legacyhub/core/utils/constants/svg_path.dart';
import 'package:legacyhub/core/utils/helpers/svg_icon_helper.dart';
import 'package:legacyhub/core/utils/validators/app_validator.dart';
import 'package:legacyhub/features/authentication/controllers/auth_controller.dart';
import 'package:legacyhub/features/authentication/views/widgets/gradient_auth_background.dart';
import 'package:lottie/lottie.dart';

/// Forgot Password Screen — matches Figma design node 803:525
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AuthController.instance;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final emailCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

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
                  SizedBox(height: 8.h),

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
                    child: Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Stack(
                        children: [
                          // Mail icon (Lottie animation)
                          Transform.translate(
                            offset: Offset(0, -30.h),
                            child: Lottie.asset(
                              LottiePath.emailVerification,
                              height: 260.h,
                              fit: BoxFit.contain,
                            ),
                          ),

                          Column(
                            children: [
                              SizedBox(height: 200.h),
                              // Title
                              Text(
                                AppStrings.authForgotPasswordTitle,
                                style: getHeadingStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 12.h),

                              // Description
                              Text(
                                AppStrings.authForgotPasswordDesc,
                                style: getTextStyle(
                                  fontSize: 14,
                                  color: isDark
                                      ? Colors.white70
                                      : const Color(0xFF6C757D),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 24.h),

                              // Email label
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AppStrings.authEmailAddress,
                                  style: getTextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),

                              SizedBox(height: 8.h),

                              // Email field
                              AppTextField(
                                controller: emailCtrl,
                                hintText: AppStrings.authEmailHint,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                prefixIcon: Icon(
                                  Iconsax.sms,
                                  size: 20.sp,
                                  color: const Color(0xFF99A1AF),
                                ),
                                validator: AppValidator.validateEmail,
                                onSubmitted: (_) {
                                  if (formKey.currentState!.validate()) {
                                    controller.forgotPassword(
                                      emailCtrl.text.trim(),
                                    );
                                  }
                                },
                              ),
                              SizedBox(height: 24.h),

                              // Send Reset Link button
                              Obx(
                                () => GradientActionButton(
                                  text: AppStrings.authSendResetLink,
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      controller.forgotPassword(
                                        emailCtrl.text.trim(),
                                      );
                                    }
                                  },
                                  isLoading: controller.isLoading.value,
                                ),
                              ),
                              SizedBox(height: 20.h),

                              // Back to Login
                              GestureDetector(
                                onTap: () => Get.back(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Iconsax.arrow_left_2,
                                      size: 16.sp,
                                      color: isDark
                                          ? Colors.white70
                                          : const Color(0xFF6C757D),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      AppStrings.authBackToLogin,
                                      style: getTextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: isDark
                                            ? Colors.white70
                                            : const Color(0xFF6C757D),
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
