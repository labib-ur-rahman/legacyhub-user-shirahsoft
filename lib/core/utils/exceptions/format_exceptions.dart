/// Custom exception class to handle various format-related errors.
class SLFormatException implements Exception {
  /// The associated error message.
  final String message;

  /// Default constructor with a generic error message.
  const SLFormatException([
    this.message =
        'An unexpected format error occurred. Please check your input.',
  ]);

  /// Create a format exception from a specific error message.
  factory SLFormatException.fromMessage(String message) {
    return SLFormatException(message);
  }

  /// Get the corresponding error message.
  String get formattedMessage => message;

  /// Create a format exception from a specific error code.
  factory SLFormatException.fromCode(String code) {
    switch (code) {
      // Common format errors
      case 'invalid-email-format':
        return const SLFormatException(
          'The email address format is invalid. Please enter a valid email (e.g., user@example.com).',
        );

      case 'invalid-phone-number-format':
        return const SLFormatException(
          'Invalid phone number format. Please enter a valid number with country code (e.g., +1234567890).',
        );

      case 'invalid-date-format':
        return const SLFormatException(
          'Invalid date format. Please use YYYY-MM-DD format.',
        );

      case 'invalid-url-format':
        return const SLFormatException(
          'Invalid URL format. Please include http:// or https:// prefix.',
        );

      case 'invalid-credit-card-format':
        return const SLFormatException(
          'Invalid credit card format. Please enter 13-16 digit card number.',
        );

      case 'invalid-numeric-format':
        return const SLFormatException(
          'Invalid numeric format. Only digits are allowed.',
        );

      // Name/Text format errors
      case 'invalid-name-format':
        return const SLFormatException(
          'Name contains invalid characters. Only letters and spaces are allowed.',
        );

      case 'invalid-username-format':
        return const SLFormatException(
          'Username must be 4-20 characters and can only contain letters, numbers, and underscores.',
        );

      // Password/Code format errors
      case 'invalid-password-format':
        return const SLFormatException(
          'Password must be 8+ characters with mix of upper/lower case, numbers, and symbols.',
        );

      case 'invalid-pin-format':
        return const SLFormatException('PIN must be 4-6 digits.');

      case 'invalid-verification-code-format':
        return const SLFormatException('Verification code must be 6 digits.');

      // Location/Address format errors
      case 'invalid-postal-code-format':
        return const SLFormatException(
          'Invalid postal code format for your region.',
        );

      case 'invalid-address-format':
        return const SLFormatException(
          'Address must include street, city, and postal code.',
        );

      case 'invalid-coordinate-format':
        return const SLFormatException(
          'Invalid geographic coordinates format. Use decimal degrees (e.g., 40.7128, -74.0060).',
        );

      // Financial format errors
      case 'invalid-currency-format':
        return const SLFormatException(
          'Invalid currency format. Use standard format (e.g., 1000.00 or 1,000.00).',
        );

      case 'invalid-price-format':
        return const SLFormatException(
          'Invalid price format. Only numbers and decimal points are allowed.',
        );

      // Technical format errors
      case 'invalid-hex-color-format':
        return const SLFormatException(
          'Invalid color format. Use 6-character hex code (e.g., #FF0000).',
        );

      case 'invalid-ip-format':
        return const SLFormatException(
          'Invalid IP address format. Use IPv4 (e.g., 192.168.1.1) or IPv6 format.',
        );

      case 'invalid-mac-format':
        return const SLFormatException(
          'Invalid MAC address format. Use 00:1A:C2:7B:00:47 format.',
        );

      case 'invalid-uuid-format':
        return const SLFormatException(
          'Invalid UUID format. Use 8-4-4-4-12 hexadecimal format.',
        );

      case 'invalid-base64-format':
        return const SLFormatException('Invalid Base64 encoded string format.');

      case 'invalid-json-format':
        return const SLFormatException(
          'Invalid JSON format. Check your syntax.',
        );

      // File/Data format errors
      case 'invalid-file-format':
        return const SLFormatException(
          'Unsupported file format. Please check file type requirements.',
        );

      case 'invalid-image-format':
        return const SLFormatException(
          'Unsupported image format. Use JPG, PNG, or GIF.',
        );

      case 'invalid-csv-format':
        return const SLFormatException(
          'Invalid CSV format. Check column consistency and delimiters.',
        );

      // Time format errors
      case 'invalid-time-format':
        return const SLFormatException(
          'Invalid time format. Use HH:MM (24-hour) format.',
        );

      case 'invalid-datetime-format':
        return const SLFormatException(
          'Invalid date/time format. Use ISO 8601 format (YYYY-MM-DDTHH:MM:SS).',
        );

      // Default case for unknown format codes
      default:
        return SLFormatException(
          'Invalid format: $code. Please check your input.',
        );
    }
  }
}
