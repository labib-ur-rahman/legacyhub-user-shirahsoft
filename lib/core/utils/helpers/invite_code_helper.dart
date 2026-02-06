import 'dart:math';

/// Invite Code Helper - Generates and validates LegacyHub invite codes
/// Format: S + 6 random characters + L (e.g., SA7K9Q2L)
class InviteCodeHelper {
  InviteCodeHelper._();

  // ==================== Constants ====================

  /// Character set for invite code generation
  /// Excludes: O, I, l, 0, 1 (to avoid confusion)
  static const String _charset = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';

  /// Invite code prefix
  static const String _prefix = 'S';

  /// Invite code suffix
  static const String _suffix = 'L';

  /// Total length of invite code
  static const int _codeLength = 8;

  /// Length of random portion
  static const int _randomLength = 6;

  // ==================== Generation ====================

  /// Generate a new unique invite code
  /// Format: S + 6_CHARS + L (e.g., SA7K9Q2L)
  static String generate() {
    final random = Random.secure();
    final code = List.generate(
      _randomLength,
      (_) => _charset[random.nextInt(_charset.length)],
    ).join();
    return '$_prefix$code$_suffix';
  }

  /// Generate multiple unique invite codes
  static List<String> generateBatch(int count) {
    final codes = <String>{};
    while (codes.length < count) {
      codes.add(generate());
    }
    return codes.toList();
  }

  // ==================== Validation ====================

  /// Validate invite code format
  /// Returns true if code matches format: S + 6 valid chars + L
  static bool isValid(String code) {
    // Check length
    if (code.length != _codeLength) return false;

    // Check prefix and suffix
    if (!code.startsWith(_prefix) || !code.endsWith(_suffix)) return false;

    // Check middle characters
    final middle = code.substring(1, 7);
    return middle.split('').every((char) => _charset.contains(char));
  }

  /// Validate and normalize invite code (uppercase, trim)
  static String? normalizeAndValidate(String? input) {
    if (input == null || input.isEmpty) return null;

    // Remove spaces and dashes, convert to uppercase
    final normalized = input.replaceAll(RegExp(r'[\s\-]'), '').toUpperCase();

    // Validate
    if (isValid(normalized)) {
      return normalized;
    }
    return null;
  }

  // ==================== Formatting ====================

  /// Format invite code for display
  /// SA7K9Q2L → SA7K-9Q2L
  static String format(String code) {
    if (code.length != _codeLength) return code;
    return '${code.substring(0, 4)}-${code.substring(4)}';
  }

  /// Remove formatting from invite code
  /// SA7K-9Q2L → SA7K9Q2L
  static String unformat(String formattedCode) {
    return formattedCode.replaceAll('-', '').toUpperCase();
  }

  // ==================== Utilities ====================

  /// Get total possible combinations
  /// 32^6 ≈ 1,073,741,824 unique codes
  static int get totalCombinations {
    return pow(_charset.length, _randomLength).toInt();
  }

  /// Check if a character is valid for invite codes
  static bool isValidCharacter(String char) {
    return _charset.contains(char.toUpperCase());
  }

  /// Get the valid character set
  static String get validCharacters => _charset;
}
