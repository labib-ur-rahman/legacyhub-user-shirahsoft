/// ============================================================================
/// API MODELS - Reusable API Response Models
/// ============================================================================
/// Contains shared models for API communication:
/// - ApiMeta: Pagination metadata
/// - PaginatedResponse: Paginated list responses
///
/// Note: ApiResponse and ApiError are defined in http_client.dart
/// ============================================================================
library;

/// API Meta information for pagination and additional data
/// Used with paginated API responses to provide navigation info
///
/// Example response:
///   {
///     "data": [...],
///     "meta": {
///       "current_page": 1,
///       "last_page": 10,
///       "per_page": 20,
///       "total": 200
///     }
///   }
class ApiMeta {
  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;
  final String? path;
  final String? nextPageUrl;
  final String? prevPageUrl;

  ApiMeta({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.path,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory ApiMeta.fromJson(Map<String, dynamic> json) {
    return ApiMeta(
      currentPage: json['current_page']?.toInt(),
      lastPage: json['last_page']?.toInt(),
      perPage: json['per_page']?.toInt(),
      total: json['total']?.toInt(),
      path: json['path']?.toString(),
      nextPageUrl: json['next_page_url']?.toString(),
      prevPageUrl: json['prev_page_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
      'path': path,
      'next_page_url': nextPageUrl,
      'prev_page_url': prevPageUrl,
    };
  }
}

/// Paginated List Response wrapper
/// Generic model for paginated API responses with data and meta information
///
/// Usage:
///   final response = await HttpService.get<PaginatedResponse<User>>(
///     '/users',
///     fromJson: (json) => PaginatedResponse.fromJson(json, User.fromJson),
///   );
///
///   if (response.isSuccess) {
///     final users = response.data!.data; // List<User>
///     final totalPages = response.data!.meta.lastPage;
///   }
class PaginatedResponse<T> {
  final List<T> data;
  final ApiMeta meta;

  PaginatedResponse({required this.data, required this.meta});

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      data: (json['data'] as List? ?? [])
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
      meta: ApiMeta.fromJson(json['meta'] ?? {}),
    );
  }
}
