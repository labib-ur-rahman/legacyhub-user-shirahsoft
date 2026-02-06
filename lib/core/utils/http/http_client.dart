import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:legacyhub/core/services/logger_service.dart';
import 'package:legacyhub/core/services/local_storage_service.dart';
import 'package:legacyhub/core/utils/constants/app_constants.dart';
import 'package:legacyhub/core/utils/constants/enums.dart';

/// ============================================================================
/// HTTP SERVICE - Professional API Communication Layer
/// ============================================================================
/// Handles all HTTP requests with authentication, error handling, and logging.
///
/// Features:
/// - Environment-based URL configuration (Dev/Staging/Production)
/// - Bearer token authentication with auto-logout on 401
/// - Comprehensive error handling with typed errors
/// - Request/response logging with LoggerService
/// - File upload support (multipart)
/// - Validation error extraction
/// - Type-safe generic responses
///
/// Models Exported:
/// - ApiResponse<T>: Generic response wrapper (success/error)
/// - ApiError: Detailed error information
/// - ApiErrorType: Error categorization (network, validation, etc.)
///
/// Usage:
///   // Initialize once
///   HttpService.init();
///
///   // GET request
///   final response = await HttpService.get<User>(
///     '/users/1',
///     fromJson: User.fromJson,
///   );
///
///   if (response.isSuccess) {
///     print('User: ${response.data}');
///   } else {
///     print('Error: ${response.error?.message}');
///   }
/// ============================================================================

class HttpService {
  // ============================================================================
  // STATIC PROPERTIES
  // ============================================================================
  static http.Client? _client;
  static String? _baseUrl;

  // ============================================================================
  // INITIALIZATION
  // ============================================================================

  /// Initialize HTTP service with optional custom base URL
  /// If no URL provided, uses environment-specific URL
  ///
  /// Example:
  ///   HttpService.init(baseUrl: 'https://api.production.com');
  static void init({String? baseUrl}) {
    _client = http.Client();
    _baseUrl = baseUrl ?? _getEnvironmentBaseUrl();
    LoggerService.info('🌐 HTTP Service initialized with base URL: $_baseUrl');
  }

  /// Get environment-specific base URL
  /// - Debug: Development API
  /// - Profile: Staging API
  /// - Release: Production API
  static String _getEnvironmentBaseUrl() {
    if (kDebugMode) {
      return AppConstants.devApiUrl;
    } else if (kProfileMode) {
      return AppConstants.stagingApiUrl;
    } else {
      return AppConstants.baseApiUrl;
    }
  }

  // ============================================================================
  // HEADER BUILDING - Private Helper Methods
  // ============================================================================

  /// Build standard API headers with optional authentication
  /// Supports multiple authentication strategies:
  /// - Standard Bearer token (default)
  /// - Token without 'Bearer ' prefix
  /// - Custom headers
  ///
  /// Returns headers Map with Content-Type, Accept, and Authorization if required
  static Future<Map<String, String>> _getHeaders({
    bool requireAuth = true,
    bool? isTokenWithoutBearer,
    Map<String, String>? additionalHeaders,
  }) async {
    final headers = _buildBaseHeaders();

    // Add authentication if required
    if (requireAuth) {
      _addAuthorizationHeader(headers, isTokenWithoutBearer ?? false);
    }

    // Add custom headers if provided
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  /// Build base headers with Content-Type and Accept
  static Map<String, String> _buildBaseHeaders() {
    return <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  /// Add authorization header with token
  /// If [withoutBearer] is true, adds raw token without 'Bearer ' prefix
  static void _addAuthorizationHeader(
    Map<String, String> headers,
    bool withoutBearer,
  ) async {
    final token = await LocalStorageService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = withoutBearer ? token : 'Bearer $token';
    }
  }

  // ============================================================================
  // PUBLIC REQUEST METHODS
  // ============================================================================
  // Each method follows the same pattern:
  // 1. Build URI with query parameters
  // 2. Prepare headers
  // 3. Log request details
  // 4. Make HTTP request with timeout
  // 5. Handle response or catch errors

  /// GET Request
  ///
  /// Parameters:
  ///   - endpoint: API endpoint (relative or absolute URL)
  ///   - queryParams: Optional query parameters
  ///   - requireAuth: Whether to include Authorization header (default: true)
  ///   - additionalHeaders: Custom headers to include
  ///   - fromJson: JSON deserializer function for response data
  ///
  /// Returns: ApiResponse<T> with data on success or error on failure
  ///
  /// Example:
  ///   final response = await HttpService.get<User>('/users/1', fromJson: User.fromJson);
  ///   if (response.isSuccess) {
  ///     print(response.data);
  ///   } else {
  ///     print(response.error);
  ///   }
  static Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    bool requireAuth = true,
    Map<String, String>? additionalHeaders,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final headers = await _getHeaders(
        requireAuth: requireAuth,
        additionalHeaders: additionalHeaders,
      );

      _logRequest('GET', uri, headers);

      final response = await _client!
          .get(uri, headers: headers)
          .timeout(Duration(seconds: AppConstants.apiTimeoutDuration));

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      LoggerService.error('❌ GET Request failed: $endpoint', e);
      return ApiResponse.error(_handleError(e));
    }
  }

  /// POST Request
  ///
  /// Parameters:
  ///   - endpoint: API endpoint (relative or absolute URL)
  ///   - data: Request body data (automatically JSON encoded)
  ///   - queryParams: Optional query parameters
  ///   - requireAuth: Whether to include Authorization header (default: true)
  ///   - additionalHeaders: Custom headers to include
  ///   - fromJson: JSON deserializer function for response data
  ///
  /// Returns: ApiResponse<T> with data on success or error on failure
  ///
  /// Example:
  ///   final response = await HttpService.post<User>('/users', data: {'name': 'John'}, fromJson: User.fromJson);
  static Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    bool requireAuth = true,
    Map<String, String>? additionalHeaders,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final headers = await _getHeaders(
        requireAuth: requireAuth,
        additionalHeaders: additionalHeaders,
      );

      _logRequest('POST', uri, headers, data);

      final response = await _client!
          .post(
            uri,
            headers: headers,
            body: data != null ? json.encode(data) : null,
          )
          .timeout(Duration(seconds: AppConstants.apiTimeoutDuration));

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      LoggerService.error('❌ POST Request failed: $endpoint', e);
      return ApiResponse.error(_handleError(e));
    }
  }

  /// PUT Request
  ///
  /// Parameters:
  ///   - endpoint: API endpoint (relative or absolute URL)
  ///   - data: Request body data (automatically JSON encoded)
  ///   - queryParams: Optional query parameters
  ///   - requireAuth: Whether to include Authorization header (default: true)
  ///   - additionalHeaders: Custom headers to include
  ///   - fromJson: JSON deserializer function for response data
  ///
  /// Returns: ApiResponse<T> with data on success or error on failure
  ///
  /// Example:
  ///   final response = await HttpService.put<User>('/users/1', data: {'name': 'Jane'}, fromJson: User.fromJson);
  static Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    bool requireAuth = true,
    Map<String, String>? additionalHeaders,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final headers = await _getHeaders(
        requireAuth: requireAuth,
        additionalHeaders: additionalHeaders,
      );

      _logRequest('PUT', uri, headers, data);

      final response = await _client!
          .put(
            uri,
            headers: headers,
            body: data != null ? json.encode(data) : null,
          )
          .timeout(Duration(seconds: AppConstants.apiTimeoutDuration));

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      LoggerService.error('❌ PUT Request failed: $endpoint', e);
      return ApiResponse.error(_handleError(e));
    }
  }

  /// PATCH Request
  ///
  /// Parameters:
  ///   - endpoint: API endpoint (relative or absolute URL)
  ///   - data: Request body data (automatically JSON encoded)
  ///   - queryParams: Optional query parameters
  ///   - requireAuth: Whether to include Authorization header (default: true)
  ///   - additionalHeaders: Custom headers to include
  ///   - fromJson: JSON deserializer function for response data
  ///
  /// Returns: ApiResponse<T> with data on success or error on failure
  ///
  /// Example:
  ///   final response = await HttpService.patch<User>('/users/1', data: {'email': 'new@example.com'}, fromJson: User.fromJson);
  static Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    bool requireAuth = true,
    Map<String, String>? additionalHeaders,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final headers = await _getHeaders(
        requireAuth: requireAuth,
        additionalHeaders: additionalHeaders,
      );

      _logRequest('PATCH', uri, headers, data);

      final response = await _client!
          .patch(
            uri,
            headers: headers,
            body: data != null ? json.encode(data) : null,
          )
          .timeout(Duration(seconds: AppConstants.apiTimeoutDuration));

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      LoggerService.error('❌ PATCH Request failed: $endpoint', e);
      return ApiResponse.error(_handleError(e));
    }
  }

  /// DELETE Request
  ///
  /// Parameters:
  ///   - endpoint: API endpoint (relative or absolute URL)
  ///   - queryParams: Optional query parameters
  ///   - requireAuth: Whether to include Authorization header (default: true)
  ///   - additionalHeaders: Custom headers to include
  ///   - fromJson: JSON deserializer function for response data
  ///
  /// Returns: ApiResponse<T> with data on success or error on failure
  ///
  /// Example:
  ///   final response = await HttpService.delete<bool>('/users/1');
  static Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    bool requireAuth = true,
    Map<String, String>? additionalHeaders,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final headers = await _getHeaders(
        requireAuth: requireAuth,
        additionalHeaders: additionalHeaders,
      );

      _logRequest('DELETE', uri, headers);

      final response = await _client!
          .delete(uri, headers: headers)
          .timeout(Duration(seconds: AppConstants.apiTimeoutDuration));

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      LoggerService.error('❌ DELETE Request failed: $endpoint', e);
      return ApiResponse.error(_handleError(e));
    }
  }

  /// Upload File (Multipart Request)
  ///
  /// Parameters:
  ///   - endpoint: API endpoint (relative or absolute URL)
  ///   - file: File to upload
  ///   - fieldName: Form field name for the file
  ///   - fields: Optional additional form fields
  ///   - requireAuth: Whether to include Authorization header (default: true)
  ///   - additionalHeaders: Custom headers to include
  ///   - fromJson: JSON deserializer function for response data
  ///
  /// Returns: ApiResponse<T> with data on success or error on failure
  ///
  /// Example:
  ///   final file = File('path/to/image.jpg');
  ///   final response = await HttpService.uploadFile<UploadResult>(
  ///     '/upload',
  ///     file: file,
  ///     fieldName: 'image',
  ///     fields: {'category': 'profile'},
  ///     fromJson: UploadResult.fromJson,
  ///   );
  static Future<ApiResponse<T>> uploadFile<T>(
    String endpoint, {
    required File file,
    required String fieldName,
    Map<String, String>? fields,
    bool requireAuth = true,
    Map<String, String>? additionalHeaders,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final headers = await _getHeaders(
        requireAuth: requireAuth,
        additionalHeaders: additionalHeaders,
      );

      LoggerService.info('🌐 UPLOAD Request: $uri');
      LoggerService.debug('📤 File: ${file.path}');

      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll(headers);

      // Add file
      request.files.add(
        await http.MultipartFile.fromPath(fieldName, file.path),
      );

      // Add form fields
      if (fields != null) {
        request.fields.addAll(fields);
        LoggerService.debug('📝 Form Fields: $fields');
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      LoggerService.error('❌ UPLOAD Request failed: $endpoint', e);
      return ApiResponse.error(_handleError(e));
    }
  }

  // ============================================================================
  // HELPER METHODS - Logging, URI Building, Response Handling
  // ============================================================================

  /// Log request details (method, URL, headers, optional data)
  static void _logRequest(
    String method,
    Uri uri, [
    Map<String, String>? headers,
    dynamic data,
  ]) {
    LoggerService.info('🌐 $method Request: $uri');
    if (headers != null) {
      LoggerService.debug('🔧 Headers: $headers');
    }
    if (data != null) {
      LoggerService.debug('📤 Data: $data');
    }
  }

  /// Build complete URI with query parameters
  /// Handles both absolute and relative URLs
  ///
  /// Examples:
  ///   _buildUri('/users', null) -> http://api.example.com/users
  ///   _buildUri('https://other.com/data', null) -> https://other.com/data
  ///   _buildUri('/users', {'page': '1'}) -> http://api.example.com/users?page=1
  static Uri _buildUri(String endpoint, [Map<String, dynamic>? queryParams]) {
    final url = endpoint.startsWith('http') ? endpoint : '$_baseUrl$endpoint';
    final uri = Uri.parse(url);

    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(
        queryParameters: {
          ...uri.queryParameters,
          ...queryParams.map((key, value) => MapEntry(key, value.toString())),
        },
      );
    }

    return uri;
  }

  // ============================================================================
  // RESPONSE HANDLING - Status Code Processing, Error Handling
  // ============================================================================

  /// Handle HTTP response based on status code
  /// Automatically deserializes JSON and handles errors
  ///
  /// Status Codes Handled:
  ///   - 200-202: Success
  ///   - 400: Bad Request
  ///   - 401: Unauthorized (triggers logout)
  ///   - 403: Forbidden
  ///   - 404: Not Found
  ///   - 422: Validation Error
  ///   - 500: Server Error
  ///   - Other: Unknown Error
  static ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJson,
  ) {
    LoggerService.info(
      '📥 Response: ${response.statusCode} - ${response.request?.url}',
    );
    LoggerService.debug('📄 Response body: ${response.body}');

    try {
      final dynamic responseData = json.decode(response.body);

      switch (response.statusCode) {
        // Success responses
        case 200:
        case 201:
        case 202:
          return _handleSuccessResponse<T>(responseData, fromJson);

        // Client errors
        case 400:
          return _handleBadRequest<T>(responseData);
        case 401:
          return _handleUnauthorized<T>(responseData);
        case 403:
          return _handleForbidden<T>(responseData);
        case 404:
          return _handleNotFound<T>(responseData);
        case 422:
          return _handleValidationError<T>(responseData);

        // Server errors
        case 500:
          return _handleServerError<T>(responseData);

        // Unknown status code
        default:
          return _handleUnknownError<T>(response.statusCode, responseData);
      }
    } catch (e) {
      LoggerService.error('❌ Response parsing failed', e);
      return ApiResponse.error(
        ApiError(
          statusCode: response.statusCode,
          message: 'Response parsing failed',
          type: ApiErrorType.parsing,
        ),
      );
    }
  }

  /// Handle successful response (200-202)
  static ApiResponse<T> _handleSuccessResponse<T>(
    dynamic responseData,
    T Function(dynamic)? fromJson,
  ) {
    LoggerService.info('✅ API request successful');
    if (fromJson != null && responseData != null) {
      return ApiResponse.success(fromJson(responseData));
    }
    return ApiResponse.success(responseData as T);
  }

  /// Handle Bad Request (400)
  static ApiResponse<T> _handleBadRequest<T>(dynamic responseData) {
    LoggerService.warning('⚠️ Bad Request (400)');
    return ApiResponse.error(
      ApiError(
        statusCode: 400,
        message: _extractErrorMessage(responseData),
        type: ApiErrorType.badRequest,
      ),
    );
  }

  /// Handle Unauthorized (401) - triggers logout
  static ApiResponse<T> _handleUnauthorized<T>(dynamic responseData) {
    LoggerService.warning('⚠️ Unauthorized (401)');
    _handleUnauthorizedAccess();
    return ApiResponse.error(
      ApiError(
        statusCode: 401,
        message: _extractErrorMessage(responseData),
        type: ApiErrorType.unauthorized,
      ),
    );
  }

  /// Handle Forbidden (403)
  static ApiResponse<T> _handleForbidden<T>(dynamic responseData) {
    LoggerService.warning('⚠️ Forbidden (403)');
    return ApiResponse.error(
      ApiError(
        statusCode: 403,
        message: _extractErrorMessage(responseData),
        type: ApiErrorType.forbidden,
      ),
    );
  }

  /// Handle Not Found (404)
  static ApiResponse<T> _handleNotFound<T>(dynamic responseData) {
    LoggerService.warning('⚠️ Not Found (404)');
    return ApiResponse.error(
      ApiError(
        statusCode: 404,
        message: _extractErrorMessage(responseData),
        type: ApiErrorType.notFound,
      ),
    );
  }

  /// Handle Validation Error (422)
  static ApiResponse<T> _handleValidationError<T>(dynamic responseData) {
    LoggerService.warning('⚠️ Validation Error (422)');
    return ApiResponse.error(
      ApiError(
        statusCode: 422,
        message: _extractErrorMessage(responseData),
        type: ApiErrorType.validation,
        validationErrors: _extractValidationErrors(responseData),
      ),
    );
  }

  /// Handle Server Error (500)
  static ApiResponse<T> _handleServerError<T>(dynamic responseData) {
    LoggerService.error('❌ Internal Server Error (500)');
    return ApiResponse.error(
      ApiError(
        statusCode: 500,
        message: _extractErrorMessage(responseData),
        type: ApiErrorType.serverError,
      ),
    );
  }

  /// Handle Unknown Error (other status codes)
  static ApiResponse<T> _handleUnknownError<T>(
    int statusCode,
    dynamic responseData,
  ) {
    LoggerService.error('❌ Unknown Error ($statusCode)');
    return ApiResponse.error(
      ApiError(
        statusCode: statusCode,
        message: _extractErrorMessage(responseData),
        type: ApiErrorType.unknown,
      ),
    );
  }

  // ============================================================================
  // ERROR HANDLING - Exception & Error Message Extraction
  // ============================================================================

  /// Handle different types of exceptions
  /// Converts exceptions to ApiError with appropriate error type
  ///
  /// Handles:
  ///   - SocketException: Network connectivity issues
  ///   - TimeoutException: Request timeouts
  ///   - Other: Generic unknown errors
  static ApiError _handleError(dynamic error) {
    if (error is SocketException) {
      LoggerService.error('❌ Network Error: No internet connection');
      return ApiError(
        message: 'No internet connection',
        type: ApiErrorType.network,
      );
    } else if (error.toString().contains('TimeoutException')) {
      LoggerService.error('❌ Timeout Error: Request timeout');
      return ApiError(message: 'Request timeout', type: ApiErrorType.timeout);
    } else {
      LoggerService.error('❌ Unknown Error: $error');
      return ApiError(
        message: 'Something went wrong',
        type: ApiErrorType.unknown,
      );
    }
  }

  /// Extract error message from API response
  /// Attempts to find error message in common response formats:
  /// - message field
  /// - error field
  /// - detail field
  ///
  /// Falls back to generic message if none found
  static String _extractErrorMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      return responseData['message'] ??
          responseData['error'] ??
          responseData['detail'] ??
          'Something went wrong';
    }
    return 'Something went wrong';
  }

  /// Extract validation errors from API response
  /// Attempts to extract errors from 'errors' field
  /// Returns Map<fieldName, List<errorMessages>>
  ///
  /// Example response:
  /// {
  ///   "errors": {
  ///     "email": ["Invalid email", "Already exists"],
  ///     "password": ["Too short"]
  ///   }
  /// }
  static Map<String, List<String>>? _extractValidationErrors(
    dynamic responseData,
  ) {
    if (responseData is Map<String, dynamic> &&
        responseData.containsKey('errors')) {
      final errors = responseData['errors'];
      if (errors is Map<String, dynamic>) {
        return errors.map((key, value) {
          if (value is List) {
            return MapEntry(key, value.cast<String>());
          } else if (value is String) {
            return MapEntry(key, [value]);
          }
          return MapEntry(key, [value.toString()]);
        });
      }
    }
    return null;
  }

  /// Handle unauthorized access - clears tokens and triggers logout
  /// Called when 401 response is received
  static void _handleUnauthorizedAccess() {
    LocalStorageService.clearTokens();
    LoggerService.warning('⚠️ User logged out due to unauthorized access');
    // You can add navigation to login screen here if needed
    // Get.offAllNamed(AppRoutes.login);
  }

  // ============================================================================
  // CLEANUP
  // ============================================================================

  /// Dispose HTTP client - call on app shutdown
  /// Closes the underlying HTTP client connection
  static void dispose() {
    _client?.close();
    _client = null;
    LoggerService.info('🔌 HTTP Service disposed');
  }
}

// ============================================================================
// DATA MODELS - Response Wrappers and Error Handling
// ============================================================================

/// Generic API Response wrapper
///
/// Provides consistent response handling across all HTTP methods.
///
/// Usage:
///   if (response.isSuccess) {
///     final user = response.data;
///     print('Success: $user');
///   } else {
///     final error = response.error;
///     print('Error: ${error.message}');
///   }
class ApiResponse<T> {
  final T? data;
  final ApiError? error;
  final bool isSuccess;

  /// Create successful response with data
  ApiResponse.success(this.data) : error = null, isSuccess = true;

  /// Create error response with error details
  ApiResponse.error(this.error) : data = null, isSuccess = false;

  @override
  String toString() => isSuccess
      ? 'ApiResponse<$T>.success($data)'
      : 'ApiResponse.error($error)';
}

/// API Error information
///
/// Contains detailed error information including:
/// - HTTP status code
/// - Error message
/// - Error type (for categorized handling)
/// - Validation errors (if applicable)
///
/// Example:
///   if (error.type == ApiErrorType.validation) {
///     final fieldErrors = error.validationErrors;
///     fieldErrors?.forEach((field, messages) {
///       print('$field: $messages');
///     });
///   }
class ApiError {
  final int? statusCode;
  final String message;
  final ApiErrorType type;
  final Map<String, List<String>>? validationErrors;

  ApiError({
    this.statusCode,
    required this.message,
    required this.type,
    this.validationErrors,
  });

  /// Check if this is a validation error
  bool get isValidationError => type == ApiErrorType.validation;

  /// Check if this is a network error
  bool get isNetworkError => type == ApiErrorType.network;

  /// Check if this is an authentication error
  bool get isAuthError => type == ApiErrorType.unauthorized;

  @override
  String toString() {
    return 'ApiError{statusCode: $statusCode, message: $message, type: $type}';
  }
}
