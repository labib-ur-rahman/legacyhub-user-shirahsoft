import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/core/common/widgets/buttons/gradient_action_button.dart';
import 'package:legacyhub/core/common/widgets/text_fields/app_text_field.dart';
import 'package:legacyhub/core/localization/app_string_localizations.dart';
import 'package:legacyhub/core/utils/validators/app_validator.dart';
import 'package:legacyhub/features/authentication/controllers/auth_controller.dart';
import 'package:legacyhub/features/authentication/views/screens/signup_screen.dart';
import 'package:legacyhub/features/authentication/views/widgets/gradient_auth_background.dart';
import 'package:legacyhub/routes/app_routes.dart';

/// Invite Code Screen — shown to Google Sign-in users who need to
/// provide phone number and invite code to complete profile.
/// Full screen design following Forgot Password layout style.
class InviteCodeScreen extends StatelessWidget {
  const InviteCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AuthController.instance;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final phoneCtrl = TextEditingController();
    final inviteCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          _showCancelDialog(controller);
        }
      },
      child: Scaffold(
        body: GradientAuthBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 16.h),

                    // Back button (cancel)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => _showCancelDialog(controller),
                        child: Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            Iconsax.arrow_left_2,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 60.h),

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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: formKey,
                        child: Column(
                          children: [
                            // Shield icon
                            Container(
                              width: 80.w,
                              height: 80.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF00C6FF),
                                    Color(0xFF006AED),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF006AED,
                                    ).withValues(alpha: 0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Iconsax.ticket_star,
                                size: 36.sp,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 24.h),

                            // Title
                            Text(
                              AppStrings.authCompleteProfile,
                              style: getTextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w900,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1A1A1A),
                                lineHeight: 1,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 12.h),

                            // Description
                            Text(
                              AppStrings.authCompleteProfileDesc,
                              style: getTextStyle(
                                fontSize: 14.sp,
                                color: isDark
                                    ? Colors.white70
                                    : const Color(0xFF6C757D),
                                lineHeight: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 24.h),

                            // Phone field
                            AppTextField(
                              controller: phoneCtrl,
                              hintText: AppStrings.authPhoneHint,
                              labelText: AppStrings.phoneNumber,
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

                            // Invite Code field
                            AppTextField(
                              controller: inviteCtrl,
                              hintText: AppStrings.enterInviteCode,
                              labelText: AppStrings.enterInviteCode,
                              textInputAction: TextInputAction.done,
                              prefixIcon: Icon(
                                Iconsax.ticket,
                                size: 20.sp,
                                color: const Color(0xFF99A1AF),
                              ),
                              inputFormatters: [
                                UpperCaseTextFormatter(),
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[ABCDEFGHJKLMNPQRSTUVWXYZ23456789]'),
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

                            // Complete Profile button
                            Obx(
                              () => GradientActionButton(
                                text: AppStrings.authCompleteSignup,
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    controller.phoneController.text =
                                        phoneCtrl.text;
                                    controller.inviteCodeController.text =
                                        inviteCtrl.text;
                                    controller.completeGoogleSignup();
                                  }
                                },
                                isLoading: controller.isLoading.value,
                                showArrow: false,
                              ),
                            ),
                            SizedBox(height: 20.h),

                            // Cancel
                            GestureDetector(
                              onTap: () => _showCancelDialog(controller),
                              child: Text(
                                AppStrings.cancel,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? Colors.white70
                                      : const Color(0xFF6C757D),
                                ),
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
      ),
    );
  }

  /// Show cancel confirmation — will delete auth user
  void _showCancelDialog(AuthController controller) {
    Get.dialog(
      AlertDialog(
        title: Text(AppStrings.authCancelSignup),
        content: Text(AppStrings.authCancelSignupDesc),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(AppStrings.authStay),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await controller.cancelGoogleSignup();
              Get.offAllNamed(AppRoutes.LOGIN);
            },
            child: Text(
              AppStrings.authLeave,
              style: const TextStyle(color: Color(0xFFD32F2F)),
            ),
          ),
        ],
      ),
    );
  }
}
