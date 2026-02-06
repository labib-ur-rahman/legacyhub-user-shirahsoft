/// Exception class for handling various platform-related errors.
class SLPlatformException implements Exception {
  /// The error code associated with the exception.
  final String code;

  /// Constructor that takes an error code.
  SLPlatformException(this.code);

  /// Get the corresponding error message based on the error code.
  String get message {
    switch (code) {
      // Authentication & Security
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Invalid login credentials. Please double-check your information.';
      case 'invalid-password':
        return 'Incorrect password. Please try again or reset your password.';
      case 'user-disabled':
        return 'Your account has been disabled. Contact support for assistance.';
      case 'invalid-verification-id':
        return 'Invalid verification ID. Please request a new verification code.';
      case 'session-expired':
        return 'Your session has expired. Please sign in again.';
      case 'requires-recent-login':
        return 'This operation requires recent authentication. Please sign in again.';
      case 'app-not-authorized':
        return 'This app is not authorized to perform this operation.';
      case 'keychain-error':
        return 'Keychain access error. Check your device security settings.';
      case 'biometric-not-supported':
        return 'Biometric authentication is not supported on this device.';
      case 'biometric-locked-out':
        return 'Too many failed attempts. Biometric authentication is temporarily disabled.';
      case 'biometric-not-enrolled':
        return 'No biometric credentials enrolled. Please set up in device settings.';

      // Network & Connectivity
      case 'network-request-failed':
        return 'Network request failed. Please check your internet connection.';
      case 'no-internet':
        return 'No internet connection available. Please connect to a network.';
      case 'connection-timeout':
        return 'Connection timed out. Please try again later.';
      case 'host-unreachable':
        return 'Server unavailable. Please try again later.';
      case 'dns-failure':
        return 'Could not resolve server address. Check your network settings.';

      // Permissions & Access
      case 'permission-denied':
        return 'Permission denied. Please enable required permissions in settings.';
      case 'camera-access-denied':
        return 'Camera access denied. Please enable camera permissions.';
      case 'location-disabled':
        return 'Location services are disabled. Please enable in device settings.';
      case 'location-permission-denied':
        return 'Location permission denied. Please enable location access.';
      case 'photos-access-denied':
        return 'Photo library access denied. Please enable photo permissions.';
      case 'microphone-access-denied':
        return 'Microphone access denied. Please enable microphone permissions.';
      case 'calendar-access-denied':
        return 'Calendar access denied. Please enable calendar permissions.';

      // Device & Platform
      case 'invalid-argument':
        return 'Invalid argument provided to the platform method.';
      case 'not-implemented':
        return 'This feature is not implemented on this platform.';
      case 'service-unavailable':
        return 'Required platform service is unavailable.';
      case 'device-not-supported':
        return 'This feature is not supported on your device.';
      case 'invalid-platform-version':
        return 'Your device OS version is too old. Please update your device.';
      case 'feature-not-available':
        return 'This feature is not available in the current context.';
      case 'background-processing-restricted':
        return 'Background processing is restricted on your device.';

      // Storage & Files
      case 'storage-full':
        return 'Device storage is full. Please free up space and try again.';
      case 'file-not-found':
        return 'Requested file not found. It may have been moved or deleted.';
      case 'file-read-error':
        return 'Error reading file. It may be corrupted or inaccessible.';
      case 'file-write-error':
        return 'Error writing file. Check storage permissions and space.';
      case 'invalid-file-format':
        return 'Unsupported file format. Please use a compatible format.';

      // Media & Hardware
      case 'camera-unavailable':
        return 'Camera is unavailable. Another app may be using it.';
      case 'microphone-unavailable':
        return 'Microphone is unavailable. Another app may be using it.';
      case 'audio-recording-failed':
        return 'Audio recording failed. Check microphone permissions.';
      case 'image-capture-failed':
        return 'Image capture failed. Check camera functionality.';
      case 'video-capture-failed':
        return 'Video recording failed. Check camera and storage.';

      // Firebase Specific
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'invalid-phone-number':
        return 'The provided phone number is invalid. Please check the format.';
      case 'operation-not-allowed':
        return 'This operation is not allowed. Contact support for assistance.';
      case 'session-cookie-expired':
        return 'Session expired. Please sign in again.';
      case 'uid-already-exists':
        return 'User ID already exists. Please use a different identifier.';
      case 'sign_in_failed':
        return 'Sign-in failed. Please try again or use another method.';
      case 'app-not-installed':
        return 'Required app is not installed on your device.';
      case 'invalid-oauth-credentials':
        return 'Invalid social login credentials. Please try again.';
      case 'provider-already-linked':
        return 'Account already linked to another provider.';

      // Database & Data
      case 'data-not-found':
        return 'Requested data not found. It may have been removed.';
      case 'data-stale':
        return 'Data is out of date. Please refresh and try again.';
      case 'data-conflict':
        return 'Data conflict detected. Please resolve before proceeding.';
      case 'data-too-large':
        return 'Data is too large to process. Please reduce size.';
      case 'invalid-data-format':
        return 'Invalid data format received. Please contact support.';

      // General & Fallback
      case 'internal-error':
        return 'Internal platform error. Please try again later.';
      case 'unknown-error':
        return 'An unknown platform error occurred. Please try again.';
      case 'operation-failed':
        return 'Operation failed. Please try again later.';
      case 'resource-exhausted':
        return 'Device resources exhausted. Close other apps and try again.';
      case 'quota-exceeded':
        return 'Operation quota exceeded. Please try again later.';

      // Default case for unhandled error codes
      default:
        return 'Platform error occurred. Code: $code';
    }
  }
}
