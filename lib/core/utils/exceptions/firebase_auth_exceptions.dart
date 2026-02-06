/// Custom exception class to handle Firebase authentication errors
class SLFirebaseAuthException implements Exception {
  /// The Firebase error code associated with the exception
  final String code;

  /// Default constructor
  SLFirebaseAuthException(this.code);

  /// Get user-friendly error message based on error code
  String get message {
    switch (code) {
      // Common authentication errors
      case 'email-already-in-use':
        return 'This email is already registered. Please use a different email or login.';
      case 'invalid-email':
        return 'The email address is improperly formatted. Please check your input.';
      case 'weak-password':
        return 'Password is too weak. It should be at least 6 characters.';
      case 'user-disabled':
        return 'This account has been disabled. Contact support for help.';
      case 'user-not-found':
        return 'No account found with this email. Please register first.';
      case 'wrong-password':
        return 'Incorrect password. Please try again or reset your password.';

      // Phone authentication errors
      case 'invalid-verification-code':
        return 'The SMS verification code is invalid. Please enter a valid code.';
      case 'invalid-verification-id':
        return 'Verification ID is invalid. Please request a new code.';
      case 'invalid-phone-number':
        return 'The phone number format is invalid. Please enter a valid number.';
      case 'quota-exceeded':
        return 'SMS quota exceeded. Please try again later.';
      case 'session-expired':
        return 'The SMS code has expired. Please request a new one.';

      // Account linking/credential errors
      case 'credential-already-in-use':
        return 'This account is already associated with another user.';
      case 'provider-already-linked':
        return 'This account is already linked to another sign-in method.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email but different sign-in method.';
      case 'invalid-credential':
        return 'The authentication credential is malformed or has expired.';

      // Operation restrictions
      case 'operation-not-allowed':
        return 'This authentication method is not enabled. Contact support.';
      case 'too-many-requests':
        return 'Too many requests. Please wait before trying again.';
      case 'requires-recent-login':
        return 'This operation requires recent authentication. Please login again.';

      // System/network errors
      case 'network-request-failed':
        return 'Network connection failed. Please check your internet.';
      case 'internal-error':
        return 'Internal authentication error. Please try again later.';
      case 'app-not-authorized':
        return 'The app is not authorized to use authentication.';

      // UI flow errors
      case 'popup-blocked':
        return 'The authentication popup was blocked. Please allow popups.';
      case 'popup-closed-by-user':
        return 'The authentication window was closed before completing.';
      case 'cancelled-popup-request':
        return 'The authentication request was cancelled.';

      // Default case for unknown errors
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
