import 'package:intl/intl.dart';

class AppFormatter {
  static String formatPhoneNumber(String phoneNumber) {
    // Assuming a 10-digit US phone number format: (123) 456-7890
    if (phoneNumber.length == 10) {
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)} ${phoneNumber.substring(6)}';
    } else if (phoneNumber.length == 11) {
      return '(${phoneNumber.substring(0, 4)}) ${phoneNumber.substring(4, 7)} ${phoneNumber.substring(7)}';
    }
    // Add more custom phone number formatting logic for different formats if needed.
    return phoneNumber;
  }

  // ==================== Date & Time Utilities ====================

  /// Format date to readable string
  static String formatDate(DateTime date, {String format = 'dd MMM yyyy'}) {
    try {
      return DateFormat(format).format(date);
    } catch (e) {
      return date.toString().split(' ')[0]; // Fallback to basic format
    }
  }

  /// Format time to readable string
  static String formatTime(DateTime time, {String format = 'HH:mm'}) {
    try {
      return DateFormat(format).format(time);
    } catch (e) {
      return time.toString().split(' ')[1].substring(0, 5); // Fallback to HH:mm
    }
  }

  /// Format date time to readable string
  static String formatDateTime(
    DateTime dateTime, {
    String format = 'dd MMM yyyy, HH:mm',
  }) {
    try {
      return DateFormat(format).format(dateTime);
    } catch (e) {
      return dateTime.toString().substring(0, 16); // Fallback format
    }
  }

  // ==================== String Utilities ====================

  /// Capitalize first letter of string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Capitalize first letter of each word
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }

  /// Truncate text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Remove all whitespace from string
  static String removeWhitespace(String text) {
    return text.replaceAll(RegExp(r'\s+'), '');
  }

  /// Check if string is valid email
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Check if string is valid phone number
  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(phone);
  }

  /// Check if string is valid URL
  static bool isValidUrl(String url) {
    return RegExp(r'^https?:\/\/[\w\-\.]+\.[a-zA-Z]{2,}').hasMatch(url);
  }

  /// Generate random string
  static String generateRandomString(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(
          (chars.length * DateTime.now().millisecondsSinceEpoch).toInt() %
              chars.length,
        ),
      ),
    );
  }

  // ==================== Number Utilities ====================

  /// Format number with thousand separators
  static String formatNumber(num number) {
    return NumberFormat('#,##0').format(number);
  }

  /// Format currency
  static String formatCurrency(double amount, {String symbol = '\$'}) {
    return '$symbol${NumberFormat('#,##0.00').format(amount)}';
  }

  /// Format percentage
  static String formatPercentage(double value) {
    return '${(value * 100).toStringAsFixed(1)}%';
  }

  /// Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
