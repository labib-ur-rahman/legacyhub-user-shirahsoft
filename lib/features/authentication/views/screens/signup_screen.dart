import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:legacyhub/core/common/widgets/buttons/continue_with_google_button.dart';
import 'package:legacyhub/core/common/widgets/buttons/gradient_action_button.dart';
import 'package:legacyhub/core/common/widgets/popups/full_screen_loader.dart';
import 'package:legacyhub/core/common/widgets/text_fields/app_text_field.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/core/localization/app_string_localizations.dart';
import 'package:legacyhub/core/utils/constants/lottie_path.dart';
import 'package:legacyhub/core/utils/constants/svg_path.dart';
import 'package:legacyhub/core/utils/helpers/svg_icon_helper.dart';
import 'package:legacyhub/core/utils/validators/app_validator.dart';
import 'package:legacyhub/features/authentication/controllers/auth_controller.dart';
import 'package:legacyhub/features/authentication/views/widgets/gradient_auth_background.dart';

/// Signup Screen — matches Figma design node 803:387
class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AuthController.instance;
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

                  // Back button + Title
                  _buildHeader(isDark),
                  SizedBox(height: 24.h),

                  // White card form
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
                      key: controller.signupFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          // First Name
                          AppTextField(
                            controller: controller.firstNameController,
                            hintText: AppStrings.authFirstName,
                            textInputAction: TextInputAction.next,
                            prefixIcon: Icon(
                              Iconsax.user,
                              size: 20.sp,
                              color: const Color(0xFF99A1AF),
                            ),
                            validator: (v) => AppValidator.validateEmptyText(
                              AppStrings.authFirstName,
                              v,
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Last Name
                          AppTextField(
                            controller: controller.lastNameController,
                            hintText: AppStrings.authLastNameOptional,
                            textInputAction: TextInputAction.next,
                            prefixIcon: Icon(
                              Iconsax.user,
                              size: 20.sp,
                              color: const Color(0xFF99A1AF),
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Email
                          AppTextField(
                            controller: controller.emailController,
                            hintText: AppStrings.authEmailHint,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            prefixIcon: Icon(
                              Iconsax.sms,
                              size: 20.sp,
                              color: const Color(0xFF99A1AF),
                            ),
                            validator: AppValidator.validateEmail,
                          ),
                          SizedBox(height: 16.h),

                          // Phone
                          AppTextField(
                            controller: controller.phoneController,
                            hintText: AppStrings.authPhoneHint,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            prefixIcon: Icon(
                              Iconsax.call,
                              size: 20.sp,
                              color: const Color(0xFF99A1AF),
                            ),
                            validator: AppValidator.validatePhoneNumber,
                          ),
                          SizedBox(height: 16.h),

                          // Password
                          AppTextField(
                            controller: controller.passwordController,
                            hintText: AppStrings.authPasswordHint,
                            obscureText: true,
                            textInputAction: TextInputAction.next,
                            prefixIcon: Icon(
                              Iconsax.lock,
                              size: 20.sp,
                              color: const Color(0xFF99A1AF),
                            ),
                            validator: AppValidator.validatePassword,
                          ),
                          SizedBox(height: 16.h),

                          // Confirm Password
                          AppTextField(
                            controller: controller.confirmPasswordController,
                            hintText: AppStrings.authConfirmPasswordHint,
                            obscureText: true,
                            textInputAction: TextInputAction.next,
                            prefixIcon: Icon(
                              Iconsax.lock,
                              size: 20.sp,
                              color: const Color(0xFF99A1AF),
                            ),
                            validator: (v) =>
                                AppValidator.validateConfirmPassword(
                                  v,
                                  controller.passwordController.text,
                                ),
                          ),
                          SizedBox(height: 16.h),

                          // Invite Code
                          AppTextField(
                            controller: controller.inviteCodeController,
                            hintText: AppStrings.enterInviteCode,
                            textInputAction: TextInputAction.done,
                            prefixIcon: Icon(
                              Iconsax.ticket,
                              size: 20.sp,
                              color: const Color(0xFF99A1AF),
                            ),
                            inputFormatters: [
                              UpperCaseTextFormatter(),
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[ABCDEFGHJLKMNPQRSTUVWXYZ23456789]'),
                              ),
                            ],
                            maxLength: 8,
                            validator: (v) => AppValidator.validateEmptyText(
                              AppStrings.enterInviteCode,
                              v,
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Info box
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.1)
                                    : const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '💡 ${AppStrings.authTipLabel} ',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF1A1A1A),
                                    ),
                                  ),
                                  TextSpan(
                                    text: AppStrings.authInviteCodeTip,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: isDark
                                          ? Colors.white70
                                          : const Color(0xFF6C757D),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),

                          // Sign Up button
                          Obx(
                            () => GradientActionButton(
                              text: AppStrings.authSignUp,
                              onPressed: () {
                                SLFullScreenLoader.openLoadingDialog(
                                  AppStrings.loading,
                                  LottiePath.docerAnimation,
                                );
                                controller
                                    .signupWithEmailPassword()
                                    .then((_) {
                                      SLFullScreenLoader.stopLoading();
                                    })
                                    .catchError((_) {
                                      SLFullScreenLoader.stopLoading();
                                    });
                              },
                              isLoading: controller.isLoading.value,
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // Or divider
                          _buildDivider(isDark),
                          SizedBox(height: 20.h),

                          // Continue with Google
                          Obx(
                            () => ContinueWithGoogleButton(
                              onPressed: () => controller.continueWithGoogle(),
                              isLoading: controller.isGoogleSignIn.value,
                            ),
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

  /// Back button + Sign Up title + "Already have an account? Log In"
  Widget _buildHeader(bool isDark) {
    return Column(
      children: [
        // Back button row
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

        // Title
        Text(
          AppStrings.authSignUp,
          style: getBebasNeueTextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),

        // Already have account
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.authHaveAccount,
              style: getTextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            GestureDetector(
              onTap: () => Get.back(),
              child: Text(
                AppStrings.authLogIn,
                style: getBoldTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// "Or" divider
  Widget _buildDivider(bool isDark) {
    final dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : const Color(0xFFE5E7EB);

    return Row(
      children: [
        Expanded(child: Divider(color: dividerColor, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            AppStrings.authOr,
            style: TextStyle(
              fontSize: 14.sp,
              color: isDark ? Colors.white54 : const Color(0xFF99A1AF),
            ),
          ),
        ),
        Expanded(child: Divider(color: dividerColor, thickness: 1)),
      ],
    );
  }
}

/// Converts text to uppercase as user types
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
