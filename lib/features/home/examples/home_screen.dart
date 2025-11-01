import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_template/core/localization/app_string_localizations.dart';
import 'package:project_template/core/utils/constants/app_constants.dart';
import 'package:project_template/core/utils/constants/colors.dart';
import 'package:project_template/features/home/controllers/home_controller.dart';
import 'package:project_template/features/stripe/examples/stripe_payment_webview_screen.dart';

/// Home Screen - Main dashboard/landing page of the application
/// Displays user data and main app functionality
class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(context), body: _buildBody(context));
  }

  /// Build the app bar
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(AppStrings.homeTitle),
      actions: [
        // Theme toggle button
        IconButton(
          onPressed: controller.toggleTheme,
          icon: Obx(
            () => Icon(
              controller.isDarkMode.value ? Iconsax.sun_1 : Iconsax.moon,
            ),
          ),
          tooltip: AppStrings.toggleTheme,
        ),

        // Language toggle button
        IconButton(
          onPressed: controller.toggleLanguage,
          icon: const Icon(Iconsax.language_circle),
          tooltip: AppStrings.toggleLanguage,
        ),

        60.verticalSpace,
      ],
    );
  }

  /// Build the main body
  Widget _buildBody(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(context),
            SizedBox(height: 24.h),
            _buildStripePaymentSection(context),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  /// Build welcome card
  Widget _buildWelcomeCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Iconsax.emoji_happy,
                  size: 32.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'welcome_message'.tr,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'welcome_subtitle'.tr,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
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
    );
  }

  /// Build Stripe Payment Section
  Widget _buildStripePaymentSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Iconsax.card,
                  size: 24.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 12.w),
                Text(
                  AppStrings.payment,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Test Payment Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openStripePayment(AppConstants.stripeTestUrl),
                icon: Icon(Icons.credit_card, size: 20.sp),
                label: Text(AppStrings.testStripePaymentButton),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // Custom URL Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _showCustomUrlDialog,
                icon: Icon(Icons.link, size: 20.sp),
                label: Text(AppStrings.customUrlIntegration),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  side: BorderSide(color: AppColors.primary),
                  foregroundColor: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Open Stripe Payment with URL
  void _openStripePayment(String url, {String? token}) {
    Get.to(
      () => StripePaymentWebViewScreen(paymentUrl: url, accessToken: token),
    );
  }

  /// Show custom URL dialog
  void _showCustomUrlDialog() {
    final urlController = TextEditingController();
    final tokenController = TextEditingController();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.customUrlIntegration,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 16.h),

              // URL TextField
              TextField(
                controller: urlController,
                decoration: InputDecoration(
                  labelText: 'Stripe URL',
                  hintText: 'https://checkout.stripe.com/c/pay/...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  prefixIcon: const Icon(Icons.link),
                ),
                keyboardType: TextInputType.url,
              ),

              SizedBox(height: 16.h),

              // Token TextField (Optional)
              TextField(
                controller: tokenController,
                decoration: InputDecoration(
                  labelText: 'Access Token (Optional)',
                  hintText: 'Your access token',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  prefixIcon: const Icon(Icons.key),
                ),
              ),

              SizedBox(height: 24.h),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(AppStrings.cancel),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton(
                    onPressed: () {
                      final url = urlController.text.trim();
                      final token = tokenController.text.trim();

                      if (url.isEmpty) {
                        Get.snackbar(
                          AppStrings.error,
                          'Please enter a Stripe URL',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }

                      Get.back();
                      _openStripePayment(
                        url,
                        token: token.isEmpty ? null : token,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.h),
                      child: Text('Launch Payment'),
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
