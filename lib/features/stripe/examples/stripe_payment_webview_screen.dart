import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_template/core/localization/app_string_localizations.dart';
import 'package:project_template/core/utils/constants/colors.dart';
import 'package:project_template/features/stripe/controllers/stripe_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Stripe Payment WebView Screen
///
/// Displays Stripe checkout page in a WebView
class StripePaymentWebViewScreen extends StatelessWidget {
  final String paymentUrl;
  final String? accessToken;

  const StripePaymentWebViewScreen({
    super.key,
    required this.paymentUrl,
    this.accessToken,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(
      StripeController(paymentUrl: paymentUrl, accessToken: accessToken),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppStrings.payment),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
        actions: [
          // Reload Button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.reloadPage,
            tooltip: 'Reload',
          ),
        ],
      ),
      body: Stack(
        children: [
          // WebView
          WebViewWidget(controller: controller.webViewController),

          // Loading Indicator
          Obx(
            () => controller.isLoading.value
                ? Container(
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 3.w,
                          ),
                          24.verticalSpace,
                          Text(
                            AppStrings.loadingPaymentPage,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
