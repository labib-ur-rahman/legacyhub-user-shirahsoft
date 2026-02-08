import 'package:flutter/material.dart';
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
import 'package:legacyhub/core/utils/validators/app_validator.dart';
import 'package:legacyhub/features/authentication/controllers/auth_controller.dart';
import 'package:legacyhub/features/authentication/views/widgets/gradient_auth_background.dart';
import 'package:legacyhub/routes/app_routes.dart';

/// Login Screen — matches Figma design node 803:271
/// Gradient background with white card form container
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                  SizedBox(height: 20.h),

                  // Shield icon
                  _buildLogoIcon(),
                  SizedBox(height: 20.h),

                  // Title
                  Text(
                    AppStrings.authSignInTitle,
                    style: getBebasNeueTextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),

                  // Subtitle
                  Text(
                    AppStrings.authSignInSubtitle,
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32.h),

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
                      key: controller.loginFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Continue with Google
                          Obx(
                            () => ContinueWithGoogleButton(
                              onPressed: () => controller.continueWithGoogle(),
                              isLoading: controller.isGoogleSignIn.value,
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // Divider
                          _buildDivider(isDark),
                          SizedBox(height: 20.h),

                          // Email field
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

                          // Password field
                          AppTextField(
                            controller: controller.passwordController,
                            hintText: AppStrings.authPasswordHint,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            prefixIcon: Icon(
                              Iconsax.lock,
                              size: 20.sp,
                              color: const Color(0xFF99A1AF),
                            ),
                            validator: (value) =>
                                AppValidator.validateEmptyText(
                                  AppStrings.authPassword,
                                  value,
                                ),
                            onSubmitted: (_) =>
                                controller.loginWithEmailPassword(),
                          ),
                          SizedBox(height: 16.h),

                          // Remember me + Forgot password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Remember me
                              Obx(
                                () => Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 20.w,
                                      height: 20.h,
                                      child: Checkbox(
                                        value: controller.rememberMe.value,
                                        onChanged: (v) =>
                                            controller.rememberMe.value =
                                                v ?? false,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        activeColor: const Color(0xFF006AED),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4.r,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      AppStrings.authRememberMe,
                                      style: getTextStyle(
                                        fontSize: 13,
                                        color: isDark
                                            ? Colors.white70
                                            : const Color(0xFF6C757D),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Forgot password
                              GestureDetector(
                                onTap: () =>
                                    Get.toNamed(AppRoutes.FORGOT_PASSWORD),
                                child: Text(
                                  AppStrings.authForgotPassword,
                                  style: getBoldTextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF006AED),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),

                          // Login button
                          Obx(
                            () => GradientActionButton(
                              text: AppStrings.authLogIn,
                              onPressed: () {
                                SLFullScreenLoader.openLoadingDialog(
                                  AppStrings.loading,
                                  LottiePath.docerAnimation,
                                );
                                controller
                                    .loginWithEmailPassword()
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
                          SizedBox(height: 28.h),

                          // Don't have account
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppStrings.authNoAccount,
                                  style: getTextStyle(
                                    fontSize: 14,
                                    color: isDark
                                        ? Colors.white70
                                        : const Color(0xFF6C757D),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Get.toNamed(AppRoutes.SIGNUP),
                                  child: Text(
                                    AppStrings.authSignUp,
                                    style: getBoldTextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF006AED),
                                    ),
                                  ),
                                ),
                              ],
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

  /// Shield/lock logo icon at top
  Widget _buildLogoIcon() {
    return Container(
      width: 72.w,
      height: 72.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 50,
            offset: const Offset(0, 25),
          ),
        ],
      ),
      child: Icon(
        Iconsax.shield_tick5,
        size: 40.sp,
        color: const Color(0xFF006AED),
      ),
    );
  }

  /// "Or login with" divider
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
            AppStrings.authOrLoginWith,
            style: getTextStyle(
              fontSize: 14,
              color: isDark ? Colors.white54 : const Color(0xFF99A1AF),
            ),
          ),
        ),
        Expanded(child: Divider(color: dividerColor, thickness: 1)),
      ],
    );
  }
}
