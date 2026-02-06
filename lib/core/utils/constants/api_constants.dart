/// API Constants - Centralized API configuration
/// Contains API keys, endpoints, and configuration values
class ApiConstants {
  ApiConstants._();

  // ==================== Google OAuth ====================
  /// Google OAuth Client ID for Web
  /// TODO: Replace with your actual Google Client ID from Google Cloud Console
  static const String googleClientId = '';

  /// Google OAuth Client ID for Android
  /// TODO: Replace with your actual Android Client ID
  static const String googleClientIdAndroid = '';

  /// Google OAuth Client ID for iOS
  /// TODO: Replace with your actual iOS Client ID
  static const String googleClientIdIos = '';

  // ==================== Firebase ====================
  /// Firebase project ID
  static const String firebaseProjectId = 'legacyhub-app';

  // ==================== API Endpoints ====================
  /// Base URL for backend API
  static const String baseUrl = 'https://api.legacyhub.app';

  /// API Version
  static const String apiVersion = 'v1';

  /// Full API URL
  static String get apiUrl => '$baseUrl/$apiVersion';

  // ==================== Stripe ====================
  /// Stripe Publishable Key
  /// TODO: Replace with your actual Stripe publishable key
  static const String stripePublishableKey = '';

  /// Stripe Payment endpoint
  static String get stripePaymentUrl => '$apiUrl/payments/stripe';

  // ==================== SSLCommerz ====================
  /// SSLCommerz Store ID
  /// TODO: Replace with your actual SSLCommerz Store ID
  static const String sslCommerzStoreId = '';

  /// SSLCommerz Store Password
  /// TODO: Replace with your actual SSLCommerz Store Password
  static const String sslCommerzStorePassword = '';

  /// SSLCommerz is Sandbox mode
  static const bool sslCommerzSandbox = true;

  // ==================== bKash ====================
  /// bKash App Key
  /// TODO: Replace with your actual bKash App Key
  static const String bkashAppKey = '';

  /// bKash App Secret
  /// TODO: Replace with your actual bKash App Secret
  static const String bkashAppSecret = '';

  /// bKash Username
  /// TODO: Replace with your actual bKash Username
  static const String bkashUsername = '';

  /// bKash Password
  /// TODO: Replace with your actual bKash Password
  static const String bkashPassword = '';

  /// bKash is Sandbox mode
  static const bool bkashSandbox = true;

  // ==================== Telecom APIs ====================
  /// Grameenphone API endpoint
  static const String gpApiUrl = 'https://api.gp.com.bd';

  /// Robi API endpoint
  static const String robiApiUrl = 'https://api.robi.com.bd';

  /// Banglalink API endpoint
  static const String blApiUrl = 'https://api.banglalink.net';

  /// Teletalk API endpoint
  static const String ttApiUrl = 'https://api.teletalk.com.bd';

  // ==================== Timeout Configuration ====================
  /// Connection timeout in seconds
  static const int connectionTimeout = 30;

  /// Receive timeout in seconds
  static const int receiveTimeout = 30;

  /// Send timeout in seconds
  static const int sendTimeout = 30;
}
