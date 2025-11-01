import 'package:get/get.dart';
import 'package:project_template/core/services/logger_service.dart';
import 'package:project_template/features/stripe/examples/payment_failure_screen.dart';
import 'package:project_template/features/stripe/examples/payment_success_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Simple Stripe Payment Controller
///
/// Handles Stripe payment URL loading and completion detection
class StripeController extends GetxController {
  // Observable Properties
  final RxBool isLoading = true.obs;
  final RxString currentUrl = ''.obs;

  // WebView Controller
  late WebViewController webViewController;

  // Payment Configuration
  final String paymentUrl;
  final String? accessToken;

  StripeController({required this.paymentUrl, this.accessToken});

  @override
  void onInit() {
    super.onInit();
    _initializeWebView();
  }

  /// Initialize WebView with Stripe URL
  void _initializeWebView() {
    try {
      LoggerService.info('🔧 Initializing Stripe WebView...');

      webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              LoggerService.debug('📄 Page loading: $url');
              currentUrl.value = url;
              _checkPaymentStatus(url);
            },
            onPageFinished: (String url) {
              LoggerService.debug('✅ Page loaded: $url');
              isLoading.value = false;
            },
            onWebResourceError: (WebResourceError error) {
              LoggerService.error('❌ WebView error: ${error.description}');
              isLoading.value = false;
            },
          ),
        )
        ..loadRequest(Uri.parse(paymentUrl), headers: _buildHeaders());

      LoggerService.info('✅ WebView initialized successfully');
    } catch (e) {
      LoggerService.error('❌ Failed to initialize WebView: $e');
      isLoading.value = false;
      Get.off(
        () =>
            PaymentFailureScreen(reason: e.toString(), isUserCancelled: false),
      );
    }
  }

  /// Build HTTP headers for the request
  Map<String, String> _buildHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (accessToken != null && accessToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    return headers;
  }

  /// Check payment status from URL
  void _checkPaymentStatus(String url) {
    LoggerService.debug('🔍 Checking payment status: $url');

    // Payment Success Detection
    if (url.contains('success') ||
        url.contains('payment/success') ||
        url.contains('payment_intent_client_secret') ||
        url.contains('payment-success')) {
      LoggerService.info('✅ Payment successful detected!');
      Get.off(() => const PaymentSuccessScreen());
      return;
    }

    // Payment Cancellation Detection
    if (url.contains('cancel') ||
        url.contains('payment/cancel') ||
        url.contains('payment-cancel')) {
      LoggerService.warning('⚠️ Payment cancelled by user');
      Get.off(
        () => const PaymentFailureScreen(
          reason: 'Payment was cancelled',
          isUserCancelled: true,
        ),
      );
      return;
    }

    // Payment Failure Detection
    if (url.contains('fail') ||
        url.contains('error') ||
        url.contains('payment/fail')) {
      LoggerService.error('❌ Payment failed');
      Get.off(
        () => const PaymentFailureScreen(
          reason: 'Payment processing failed',
          isUserCancelled: false,
        ),
      );
      return;
    }
  }

  /// Reload the payment page
  void reloadPage() {
    LoggerService.info('🔄 Reloading payment page');
    isLoading.value = true;
    webViewController.reload();
  }

  /// Go back in WebView history
  Future<void> goBack() async {
    final canGoBack = await webViewController.canGoBack();
    if (canGoBack) {
      LoggerService.debug('⬅️ Navigating back');
      webViewController.goBack();
    } else {
      LoggerService.debug('⬅️ Cannot go back, closing payment');
      Get.back();
    }
  }

  @override
  void onClose() {
    LoggerService.info('🔚 Closing Stripe payment controller');
    super.onClose();
  }
}
