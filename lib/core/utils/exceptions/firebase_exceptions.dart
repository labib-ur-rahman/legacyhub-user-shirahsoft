/// Custom exception class to handle various Firebase-related errors.
class SLFirebaseException implements Exception {
  /// The error code associated with the exception.
  final String code;

  /// Constructor that takes an error code.
  SLFirebaseException(this.code);

  /// Get the corresponding error message based on the error code.
  String get message {
    switch (code) {
      // General Firebase Errors
      case 'unknown':
        return 'An unknown Firebase error occurred. Please try again.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'internal-error':
        return 'Internal Firebase error. Please try again later.';
      case 'service-not-available':
        return 'Firebase service is currently unavailable.';
      case 'app-not-authorized':
        return 'The app is not authorized to use Firebase.';
      case 'keychain-error':
        return 'Keychain access error. Check device security settings.';
      case 'invalid-api-key':
        return 'Invalid Firebase API key configured.';
      case 'app-not-installed':
        return 'Required Firebase app is not installed.';

      // Authentication Errors
      case 'invalid-custom-token':
        return 'Invalid custom authentication token.';
      case 'custom-token-mismatch':
        return 'Custom token authentication mismatch.';
      case 'user-disabled':
        return 'User account has been disabled. Contact support.';
      case 'user-not-found':
        return 'No user found with these credentials.';
      case 'invalid-email':
        return 'Invalid email format. Please check your email.';
      case 'email-already-in-use':
        return 'Email already registered. Use a different email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'provider-already-linked':
        return 'Account already linked to another provider.';
      case 'operation-not-allowed':
        return 'Operation not allowed. Contact support.';
      case 'requires-recent-login':
        return 'Session expired. Please log in again.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'invalid-verification-code':
        return 'Invalid verification code.';
      case 'invalid-verification-id':
        return 'Invalid verification ID.';
      case 'session-expired':
        return 'Authentication session expired.';
      case 'invalid-credential':
        return 'Invalid authentication credentials.';
      case 'user-mismatch':
        return 'Credential does not match current user.';
      case 'account-exists-with-different-credential':
        return 'Account already exists with different credentials.';
      case 'invalid-user-token':
        return 'User token is invalid or expired.';
      case 'user-token-expired':
        return 'User token has expired. Re-authenticate.';
      case 'invalid-auth-event':
        return 'Invalid authentication event.';

      // Firestore Errors
      case 'aborted':
        return 'Operation aborted.';
      case 'already-exists':
        return 'Document already exists.';
      case 'cancelled':
        return 'Operation cancelled.';
      case 'data-loss':
        return 'Unrecoverable data loss.';
      case 'deadline-exceeded':
        return 'Operation timed out.';
      case 'failed-precondition':
        return 'Operation precondition failed.';
      case 'invalid-argument':
        return 'Invalid argument provided.';
      case 'not-found':
        return 'Requested document not found.';
      case 'out-of-range':
        return 'Operation out of valid range.';
      case 'permission-denied':
        return 'Insufficient permissions.';
      case 'resource-exhausted':
        return 'Resource exhausted.';
      case 'unauthenticated':
        return 'Authentication required.';
      case 'unavailable':
        return 'Service unavailable.';
      case 'unimplemented':
        return 'Operation not implemented.';

      // Storage Errors
      case 'bucket-not-found':
        return 'Storage bucket not found.';
      case 'canceled':
        return 'Storage operation canceled.';
      case 'cannot-slice-blob':
        return 'Cannot slice file for upload.';
      case 'server-file-wrong-size':
        return 'Uploaded file size mismatch.';
      case 'download-size-exceeded':
        return 'Download size exceeds quota.';
      case 'invalid-checksum':
        return 'File checksum mismatch.';
      case 'invalid-default-bucket':
        return 'Invalid storage bucket configured.';
      case 'invalid-event-name':
        return 'Invalid storage event name.';
      case 'object-not-found':
        return 'Storage object not found.';
      case 'project-not-found':
        return 'Storage project not found.';
      case 'quota-exceeded':
        return 'Storage quota exceeded.';
      case 'retry-limit-exceeded':
        return 'Maximum operation retries reached.';
      case 'unauthorized':
        return 'Unauthorized storage access.';
      case 'unauthorized-app':
        return 'App not authorized for storage access.';

      // Realtime Database Errors
      case 'disconnected':
        return 'Disconnected from database.';
      case 'expired-token':
        return 'Database token expired.';
      case 'invalid-token':
        return 'Invalid database token.';
      case 'max-retries':
        return 'Maximum database retries reached.';
      case 'overridden-by-set':
        return 'Data overridden by concurrent set.';
      case 'write-canceled':
        return 'Database write canceled.';

      // Default case for unhandled codes
      default:
        return 'Firebase error occurred. Code: $code';
    }
  }
}
