/// API Endpoints - Centralized API endpoint definitions
/// This file contains all API endpoints organized by feature modules
class ApiEndpoints {
  // Private constructor to prevent instantiation
  ApiEndpoints._();

  // ==================== Base Configuration ====================

  /// API version
  static const String apiVersion = 'v1';

  /// Base API path with version
  static const String basePath = '/api/$apiVersion';

  // ==================== Authentication Endpoints ====================

  /// Authentication base path
  static const String authBasePath = '$basePath/auth';

  /// User login endpoint
  static const String login = '$authBasePath/login';

  // ==================== {Features} Endpoints ====================

  /// Notifications base path
  static const String notificationsBasePath = '$basePath/notifications';

  /// Get notifications endpoint
  static const String getNotifications = notificationsBasePath;

  /// Mark notification as read endpoint
  static const String markNotificationRead = '$notificationsBasePath/{id}/read';

  // ======================= Helper Method =======================

  /// Replace path parameters in endpoint URLs
  /// Useful for dynamic routes with placeholders
  ///
  /// Example:
  ///   final endpoint = ApiEndpoints.replacePathParams(
  ///     ApiEndpoints.markNotificationRead,
  ///     {'id': '123'},
  ///   );
  ///   // Result: '/api/v1/notifications/123/read'
  ///
  /// Note: For query parameters, use HttpService methods directly:
  ///   HttpService.get('/users', queryParams: {'page': 1, 'limit': 10})
  static String replacePathParams(
    String endpoint,
    Map<String, dynamic> params,
  ) {
    String result = endpoint;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value.toString());
    });
    return result;
  }
}
