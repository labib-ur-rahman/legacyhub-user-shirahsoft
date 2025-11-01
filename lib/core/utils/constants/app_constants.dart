/// App Constants - Contains all constant values used throughout the app
/// This centralizes configuration and prevents magic numbers/strings
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // ==================== App Configuration ====================

  /// App name
  static const String appName = 'Project Template';

  /// App version
  static const String appVersion = '1.0.0';

  /// Build number
  static const int buildNumber = 1;

  /// Package name
  static const String packageName = 'com.example.project_template';

  // ==================== API Configuration ====================

  /// Base API URL for production
  static const String baseApiUrl = 'https://api.yourapp.com';

  /// Base API URL for development
  static const String devApiUrl = 'https://dev-api.yourapp.com';

  /// Base API URL for staging
  static const String stagingApiUrl = 'https://staging-api.yourapp.com';

  /// API version
  static const String apiVersion = 'v1';

  /// Full API URL
  static const String fullApiUrl = '$baseApiUrl/$apiVersion';

  /// API timeout duration (in seconds)
  static const int apiTimeoutDuration = 30;

  // ==================== Stripe Configuration ====================

  /// Stripe Test URL
  static const String stripeTestUrl =
      'https://checkout.stripe.com/c/pay/cs_test_a1qHEtDYYCmLBcZC5bze5y70bwC4yM5k34CopehUgHYLYcSeoL3bqSM5Tr#fidnandhYHdWcXxpYCc%2FJ2FgY2RwaXEnKSdkdWxOYHwnPyd1blpxYHZxWjA0V3VHaVRGbEg1ZndfdmNyYzRTNmhqMmI3Z2hgSmBQTFREQUNzUlddbE9nXDJBX099ZGQzQWt9Y2s9T3BkaWA9bk1tYVRzY1NRcFVvalUyZ21cbkRRfTVpNTVWSGB%2FaFdpVicpJ2N3amhWYHdzYHcnP3F3cGApJ2dkZm5id2pwa2FGamlqdyc%2FJyZjY2NjY2MnKSdpZHxqcHFRfHVgJz8ndmxrYmlgWmxxYGgnKSdga2RnaWBVaWRmYG1qaWFgd3YnP3F3cGB4JSUl';

  // ==================== Validation Configuration ====================

  /// Minimum password length
  static const int minPasswordLength = 8;

  /// Maximum password length
  static const int maxPasswordLength = 32;

  /// Maximum name length
  static const int maxNameLength = 50;

  /// Maximum email length
  static const int maxEmailLength = 100;

  /// Maximum phone length
  static const int maxPhoneLength = 15;

  // ==================== Pagination Configuration ====================

  /// Default page size for lists
  static const int defaultPageSize = 20;

  /// Maximum page size
  static const int maxPageSize = 100;

  // ==================== Image Configuration ====================

  /// Maximum image file size (in bytes) - 5MB
  static const int maxImageSize = 5 * 1024 * 1024;

  /// Image quality for compression (0-100)
  static const int imageQuality = 80;

  /// Maximum image width
  static const int maxImageWidth = 1024;

  /// Maximum image height
  static const int maxImageHeight = 1024;

  // ==================== Network Configuration ====================

  /// Connection timeout duration (in seconds)
  static const int connectionTimeout = 30;

  /// Receive timeout duration (in seconds)
  static const int receiveTimeout = 30;

  /// Send timeout duration (in seconds)
  static const int sendTimeout = 30;

  /// Maximum retry attempts for failed requests
  static const int maxRetryAttempts = 3;

  /// Retry delay (in milliseconds)
  static const int retryDelay = 1000;
}
