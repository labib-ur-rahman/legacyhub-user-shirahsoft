import 'package:get/get.dart';

/// Authentication Repository
/// Handles all authentication-related API operations
class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  /// Called from main.dart on app launch
  @override
  void onReady() {}

  /* ------------------------- Email & Password sign-in ----------------------*/

  /// [EmailAuthentication] - SignIn

  /// [EmailAuthentication] - REGISTER

  /// [ReAuthenticate] ReAuthenticate User

  /// [EmailVerification] MAIL VERIFICATION

  /// [EmailAuthentication] FORGET PASSWORD

  /* ------------------- Federated identity & social sign-in -----------------*/

  /// [GoogleAuthentication] GOOGLE

  ///[FacebookAuthentication] FACEBOOK

  /* --------------- ./end Federated identity & social sign-in ---------------*/

  /// [LogoutUser] Valid for any authentication.

  /// DELETE USER Remove user Auth and Firestore Account.
}
