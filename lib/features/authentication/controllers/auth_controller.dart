import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:legacyhub/core/services/firebase_service.dart';
import 'package:legacyhub/core/common/widgets/popups/custom_snackbar.dart';
import 'package:legacyhub/data/models/user/user_model.dart';
import 'package:legacyhub/data/repositories/user_repository.dart';
import 'package:legacyhub/routes/app_routes.dart';

/// Authentication Controller
/// Handles user authentication state and operations
class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  // ===== Repositories =====
  final UserRepository _userRepo = UserRepository();
  final FirebaseService _firebase = FirebaseService.instance;

  // ===== Observable State =====
  final Rx<User?> firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final RxBool isNewUser = false.obs;

  // ===== Streams =====
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<UserModel?>? _userSubscription;

  // ===== Getters =====
  String? get userId => firebaseUser.value?.uid;
  bool get hasUser => currentUser.value != null;
  String get userName => currentUser.value?.identity.fullName ?? '';
  String get userPhone => currentUser.value?.identity.phone ?? '';
  String get userAvatar => currentUser.value?.identity.avatarUrl ?? '';
  String get inviteCode => currentUser.value?.formattedInviteCode ?? '';

  @override
  void onInit() {
    super.onInit();
    _initAuthListener();
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    _userSubscription?.cancel();
    super.onClose();
  }

  /// Initialize auth state listener
  void _initAuthListener() {
    _authSubscription = _firebase.auth.authStateChanges().listen(
      (User? user) async {
        firebaseUser.value = user;

        if (user != null) {
          await _loadUserData(user.uid);
          isLoggedIn.value = true;
        } else {
          currentUser.value = null;
          isLoggedIn.value = false;
          _userSubscription?.cancel();
        }
      },
      onError: (error) {
        AppSnackBar.errorSnackBar(
          title: 'Auth Error',
          message: error.toString(),
        );
      },
    );
  }

  /// Load user data from Firestore
  Future<void> _loadUserData(String uid) async {
    try {
      // Cancel existing subscription
      _userSubscription?.cancel();

      // Stream user data for real-time updates
      _userSubscription = _userRepo
          .streamUser(uid)
          .listen(
            (user) {
              currentUser.value = user;
            },
            onError: (error) {
              AppSnackBar.errorSnackBar(
                title: 'User Data Error',
                message: error.toString(),
              );
            },
          );
    } catch (e) {
      AppSnackBar.errorSnackBar(
        title: 'Error',
        message: 'Failed to load user data',
      );
    }
  }

  // ===== Phone Authentication =====

  /// Send OTP to phone number
  Future<void> sendOTP({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    try {
      isLoading.value = true;

      await _firebase.auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification (Android only)
          await _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          isLoading.value = false;
          onError(_getAuthErrorMessage(e.code));
        },
        codeSent: (String verificationId, int? resendToken) {
          isLoading.value = false;
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto retrieval timeout
        },
      );
    } catch (e) {
      isLoading.value = false;
      onError('Failed to send OTP');
    }
  }

  /// Verify OTP and sign in
  Future<void> verifyOTP({
    required String verificationId,
    required String otp,
    String? parentInviteCode,
    required Function() onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      isLoading.value = true;

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      final userCredential = await _signInWithCredential(
        credential,
        parentInviteCode: parentInviteCode,
      );

      if (userCredential != null) {
        onSuccess();
      } else {
        onError('Failed to verify OTP');
      }
    } catch (e) {
      isLoading.value = false;
      onError('Invalid OTP');
    }
  }

  /// Sign in with credential
  Future<UserCredential?> _signInWithCredential(
    AuthCredential credential, {
    String? parentInviteCode,
  }) async {
    try {
      final userCredential = await _firebase.auth.signInWithCredential(
        credential,
      );

      final user = userCredential.user;
      if (user == null) return null;

      // Check if new user
      final existingUser = await _userRepo.getUser(user.uid);

      if (existingUser == null) {
        // New user - create profile
        isNewUser.value = true;

        String? parentUid;
        if (parentInviteCode != null && parentInviteCode.isNotEmpty) {
          final parent = await _userRepo.getUserByInviteCode(parentInviteCode);
          parentUid = parent?.uid;
        }

        await _userRepo.createNewUser(
          uid: user.uid,
          phone: user.phoneNumber ?? '',
          parentUid: parentUid,
        );
      } else {
        // Existing user - update last login
        isNewUser.value = false;
        await _userRepo.updateLastLogin(user.uid);
      }

      isLoading.value = false;
      return userCredential;
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      AppSnackBar.errorSnackBar(
        title: 'Sign In Failed',
        message: _getAuthErrorMessage(e.code),
      );
      return null;
    }
  }

  // ===== Sign Out =====

  /// Sign out user
  Future<void> signOut() async {
    try {
      isLoading.value = true;

      await _firebase.auth.signOut();
      currentUser.value = null;
      firebaseUser.value = null;
      isLoggedIn.value = false;

      isLoading.value = false;

      Get.offAllNamed(AppRoutes.LOGIN);
    } catch (e) {
      isLoading.value = false;
      AppSnackBar.errorSnackBar(
        title: 'Sign Out Failed',
        message: 'Failed to sign out',
      );
    }
  }

  // ===== Error Messages =====

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'invalid-phone-number':
        return 'Invalid phone number format';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'session-expired':
        return 'Session expired. Please request a new OTP';
      case 'invalid-verification-code':
        return 'Invalid OTP. Please try again';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      default:
        return 'Authentication failed. Please try again';
    }
  }
}
