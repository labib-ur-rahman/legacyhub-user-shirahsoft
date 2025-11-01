import 'package:get/get.dart';

/// App Strings - Centralized text constants for localization
/// All text in the app should use these constants
class AppStrings {
  AppStrings._();

  // ==================== Common ====================
  static String get error => 'error'.tr;
  static String get cancel => 'cancel'.tr;
  static String get ok => 'ok'.tr;
  static String get tryAgain => 'try_again'.tr;

  // Stripe Template Example labels
  static String get testStripePaymentButton => 'test_stripe_payment_button'.tr;
  static String get customUrlIntegration => 'custom_url_integration'.tr;

  // Payment
  static String get payment => 'payment'.tr;
  static String get paymentMethod => 'payment_method'.tr;
  static String get selectPaymentMethod => 'select_payment_method'.tr;
  static String get cardNumber => 'card_number'.tr;
  static String get expiryDate => 'expiry_date'.tr;
  static String get cvv => 'cvv'.tr;
  static String get cardholderName => 'cardholder_name'.tr;
  static String get payNow => 'pay_now'.tr;
  static String get paymentSuccessful => 'payment_successful'.tr;
  static String get paymentFailed => 'payment_failed'.tr;
  static String get paymentCancelled => 'payment_cancelled'.tr;
  static String get processingPayment => 'processing_payment'.tr;
  static String get securePayment => 'secure_payment'.tr;
  static String get cancelPayment => 'cancel_payment'.tr;
  static String get continuePayment => 'continue_payment'.tr;
  static String get cancelPaymentQuestion => 'cancel_payment_question'.tr;
  static String get cancelPaymentConfirm => 'cancel_payment_confirm'.tr;
  static String get cancelPaymentConfirmation =>
      'cancel_payment_confirmation'.tr;

  // Payment Failure
  static String get paymentCancelledMessage => 'payment_cancelled_message'.tr;
  static String get paymentFailedMessage => 'payment_failed_message'.tr;
  static String get errorDetails => 'error_details'.tr;
  static String get needHelp => 'need_help'.tr;
  static String get contactSupportMessage => 'contact_support_message'.tr;

  // Payment Success
  static String get paymentSuccessfulMessage => 'payment_successful_message'.tr;
  static String get congratulationsPremium => 'congratulations_premium'.tr;
  static String get youNowHaveAccess => 'you_now_have_access'.tr;
  static String get unlimitedAiFeedback => 'unlimited_ai_feedback'.tr;
  static String get allPremiumContent => 'all_premium_content'.tr;
  static String get advancedLearningTools => 'advanced_learning_tools'.tr;
  static String get detailedProgressAnalytics =>
      'detailed_progress_analytics'.tr;
  static String get detailedProgressAnalytic => 'detailed_progress_analytic'.tr;
  static String get prioritySupport => 'priority_support'.tr;
  static String get continueToPremium => 'continue_to_premium'.tr;

  // Stripe Payment Screen
  static String get settingUpPayment => 'setting_up_payment'.tr;
  static String get pleaseWaitPayment => 'please_wait_payment'.tr;
  static String get initializingPayment => 'initializing_payment'.tr;
  static String get almostReady => 'almost_ready'.tr;
  static String get paymentSetupFailed => 'payment_setup_failed'.tr;
  static String get reloadPayment => 'reload_payment'.tr;
  static String get webviewNotInitialized => 'webview_not_initialized'.tr;
  static String get loadingSecurePayment => 'loading_secure_payment'.tr;
  static String get connectionErrorTitle => 'connection_error_title'.tr;
  static String get reload => 'reload'.tr;
  static String get paymentWasCancelled => 'payment_was_cancelled'.tr;
  static String get loadingPaymentPage => 'loading_payment_page'.tr;
  static String get toggleTheme => 'toggle_theme'.tr;
  static String get toggleLanguage => 'toggle_language'.tr;
  static String get appTitle => 'app_title'.tr;
  static String get appTagline => 'app_tagline'.tr;

  // ==================== Home Screen ====================
  static String get homeTitle => 'home_title'.tr;
  static String get welcomeMessage => 'welcome_message'.tr;
}
