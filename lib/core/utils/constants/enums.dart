/// -- LIST of Enums
/// They cannot be created inside a class.
library;

enum ProductType { single, variable }

enum TextSizes { small, medium, large }

enum OrderStatus { processing, shipped, delivered }

enum ButtonType { primary, secondary, text }

/// API Error types
enum ApiErrorType {
  network,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  badRequest,
  validation,
  serverError,
  parsing,
  unknown,
}
