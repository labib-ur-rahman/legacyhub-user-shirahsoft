class SLValidator {
  /// Empty Text Validation
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required.';
    }

    return null;
  }

  /// Email Validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }

    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
    }

    return null;
  }

  /// Password Validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    // Check for minimum password length
    if (value.length < 8) {
      return 'Password must be at least 8 characters long.';
    }

    // Check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }

    // Check for lowercase letters
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter.';
    }

    // Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number.';
    }

    // Check for special characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character.';
    }

    return null;
  }

  /// Confirm Password Validation
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password is required.';
    }

    // Check if passwords match
    if (value != password) {
      return 'Passwords do not match.';
    }

    return null;
  }

  /// Username Validation
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required.';
    }

    if (value.length < 3) {
      return 'Username must be at least 3 characters long.';
    }

    return null;
  }

  /// Phone Number Validation
  /// Accepts only 11-digit Bangladesh phone numbers starting with 0
  /// Example: 01602475999
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required.';
    }

    // Remove spaces and dashes
    final cleanPhone = value.replaceAll(RegExp(r'[\s\-]'), '');

    // Must be exactly 11 digits and start with 01
    if (cleanPhone.length != 11) {
      return 'Phone number must be exactly 11 digits.';
    }

    if (!cleanPhone.startsWith('0')) {
      return 'Phone number must start with 0.';
    }

    // Check valid Bangladesh phone number pattern: 01[3-9]XXXXXXXX
    final phoneRegExp = RegExp(r'^01[3-9]\d{8}$');

    if (!phoneRegExp.hasMatch(cleanPhone)) {
      return 'Invalid phone number. Format: 01XXXXXXXXX';
    }

    return null;
  }

  /// Invite Code Validation
  /// Format: S + 6 random chars + L (e.g., S7J6F02L)
  static String? validateInviteCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Invite code is required.';
    }

    final code = value.trim().toUpperCase();

    // Check length (should be 8: S + 6 chars + L)
    if (code.length != 8) {
      return 'Invite code must be 8 characters long.';
    }

    // Check if it starts with 'S' and ends with 'L'
    if (!code.startsWith('S') || !code.endsWith('L')) {
      return 'Invite code must start with S and end with L.';
    }

    // Check if middle 6 characters are alphanumeric
    final middle = code.substring(1, 7);
    final alphanumericRegExp = RegExp(r'^[A-Z0-9]+$');

    if (!alphanumericRegExp.hasMatch(middle)) {
      return 'Invite code contains invalid characters.';
    }

    return null;
  }

  /// Format phone number — no country code needed
  /// Just ensures the phone is clean 11-digit format starting with 0
  /// Example: "01602475999" → "01602475999"
  static String formatPhone(String phone) {
    // Remove all non-numeric characters
    String cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');

    // Ensure it starts with 0
    if (!cleanPhone.startsWith('0') && cleanPhone.length == 10) {
      cleanPhone = '0$cleanPhone';
    }

    return cleanPhone;
  }
}
