import 'package:get/get.dart';

/// App Strings - Centralized text constants for LegacyHub localization
/// All text in the app should use these constants
class AppStrings {
  AppStrings._();

  // ==================== App Info ====================
  static String get appTitle => 'app_title'.tr;
  static String get appTagline => 'app_tagline'.tr;

  // ==================== Common ====================
  static String get error => 'error'.tr;
  static String get cancel => 'cancel'.tr;
  static String get ok => 'ok'.tr;
  static String get tryAgain => 'try_again'.tr;
  static String get loading => 'loading'.tr;
  static String get save => 'save'.tr;
  static String get done => 'done'.tr;
  static String get back => 'back'.tr;
  static String get next => 'next'.tr;
  static String get skip => 'skip'.tr;
  static String get continueText => 'continue'.tr;
  static String get submit => 'submit'.tr;
  static String get confirm => 'confirm'.tr;
  static String get close => 'close'.tr;
  static String get search => 'search'.tr;
  static String get filter => 'filter'.tr;
  static String get sort => 'sort'.tr;
  static String get refresh => 'refresh'.tr;
  static String get seeAll => 'see_all'.tr;
  static String get viewAll => 'view_all'.tr;
  static String get viewMore => 'view_more'.tr;
  static String get noData => 'no_data'.tr;
  static String get noResults => 'no_results'.tr;
  static String get comingSoon => 'coming_soon'.tr;
  static String get offline => 'offline'.tr;

  // ==================== Home Screen ====================
  static String get homeTitle => 'home_title'.tr;
  static String get welcomeMessage => 'welcome_message'.tr;
  static String get welcomeSubtitle => 'welcome_subtitle'.tr;
  static String get goodMorning => 'good_morning'.tr;
  static String get goodAfternoon => 'good_afternoon'.tr;
  static String get goodEvening => 'good_evening'.tr;
  static String get totalBalance => 'total_balance'.tr;
  static String get quickActions => 'quick_actions'.tr;
  static String get recentActivity => 'recent_activity'.tr;

  // ==================== Onboarding ====================
  static String get chooseTheme => 'choose_theme'.tr;
  static String get chooseThemeSubtitle => 'choose_theme_subtitle'.tr;
  static String get darkTheme => 'dark_theme'.tr;
  static String get lightTheme => 'light_theme'.tr;
  static String get systemTheme => 'system_theme'.tr;
  static String get darkThemeDesc => 'dark_theme_desc'.tr;
  static String get lightThemeDesc => 'light_theme_desc'.tr;
  static String get systemThemeDesc => 'system_theme_desc'.tr;
  static String get chooseLanguage => 'choose_language'.tr;
  static String get chooseLanguageSubtitle => 'choose_language_subtitle'.tr;
  static String get english => 'english'.tr;
  static String get bangla => 'bangla'.tr;
  static String get englishDesc => 'english_desc'.tr;
  static String get banglaDesc => 'bangla_desc'.tr;
  static String get getStarted => 'get_started'.tr;

  // Style Selection
  static String get chooseStyle => 'choose_style'.tr;
  static String get chooseStyleSubtitle => 'choose_style_subtitle'.tr;
  static String get styleShirah => 'style_shirah'.tr;
  static String get styleQuepal => 'style_quepal'.tr;
  static String get styleTimber => 'style_timber'.tr;
  static String get styleFlare => 'style_flare'.tr;
  static String get styleAmin => 'style_amin'.tr;
  static String get styleMidnight => 'style_midnight'.tr;
  static String get styleChanged => 'style_changed'.tr;

  // ==================== Authentication ====================
  static String get login => 'login'.tr;
  static String get loginTitle => 'login_title'.tr;
  static String get loginSubtitle => 'login_subtitle'.tr;
  static String get phoneNumber => 'phone_number'.tr;
  static String get enterPhone => 'enter_phone'.tr;
  static String get phoneHint => 'phone_hint'.tr;
  static String get invalidPhone => 'invalid_phone'.tr;
  static String get sendOtp => 'send_otp'.tr;
  static String get verifyOtp => 'verify_otp'.tr;
  static String get enterOtp => 'enter_otp'.tr;
  static String get otpSent => 'otp_sent'.tr;
  static String get otpSubtitle => 'otp_subtitle'.tr;
  static String get resendOtp => 'resend_otp'.tr;
  static String get resendIn => 'resend_in'.tr;
  static String get invalidOtp => 'invalid_otp'.tr;
  static String get verify => 'verify'.tr;
  static String get logout => 'logout'.tr;
  static String get logoutConfirm => 'logout_confirm'.tr;

  // Invite Code
  static String get haveInviteCode => 'have_invite_code'.tr;
  static String get enterInviteCode => 'enter_invite_code'.tr;
  static String get inviteCodeOptional => 'invite_code_optional'.tr;
  static String get invalidInviteCode => 'invalid_invite_code'.tr;

  // Profile Setup
  static String get setupProfile => 'setup_profile'.tr;
  static String get setupProfileSubtitle => 'setup_profile_subtitle'.tr;
  static String get yourName => 'your_name'.tr;
  static String get enterName => 'enter_name'.tr;
  static String get uploadPhoto => 'upload_photo'.tr;
  static String get changePhoto => 'change_photo'.tr;

  // ===== New Auth Flow =====
  static String get authSignInTitle => 'auth_sign_in_title'.tr;
  static String get authSignInSubtitle => 'auth_sign_in_subtitle'.tr;
  static String get authEmailHint => 'auth_email_hint'.tr;
  static String get authPasswordHint => 'auth_password_hint'.tr;
  static String get authPassword => 'auth_password'.tr;
  static String get authRememberMe => 'auth_remember_me'.tr;
  static String get authForgotPassword => 'auth_forgot_password'.tr;
  static String get authLogIn => 'auth_log_in'.tr;
  static String get authNoAccount => 'auth_no_account'.tr;
  static String get authSignUp => 'auth_sign_up'.tr;
  static String get authOrLoginWith => 'auth_or_login_with'.tr;
  static String get authOr => 'auth_or'.tr;
  static String get authFirstName => 'auth_first_name'.tr;
  static String get authLastNameOptional => 'auth_last_name_optional'.tr;
  static String get authPhoneHint => 'auth_phone_hint'.tr;
  static String get authConfirmPasswordHint => 'auth_confirm_password_hint'.tr;
  static String get authHaveAccount => 'auth_have_account'.tr;
  static String get authForgotPasswordTitle => 'auth_forgot_password_title'.tr;
  static String get authForgotPasswordDesc => 'auth_forgot_password_desc'.tr;
  static String get authEmailAddress => 'auth_email_address'.tr;
  static String get authSendResetLink => 'auth_send_reset_link'.tr;
  static String get authBackToLogin => 'auth_back_to_login'.tr;
  static String get authCheckEmailTitle => 'auth_check_email_title'.tr;
  static String get authCheckEmailSubtitle => 'auth_check_email_subtitle'.tr;
  static String get authCheckEmailInstructions =>
      'auth_check_email_instructions'.tr;
  static String get authTipLabel => 'auth_tip_label'.tr;
  static String get authCheckEmailTip => 'auth_check_email_tip'.tr;
  static String get authDidntReceiveEmail => 'auth_didnt_receive_email'.tr;
  static String get authResend => 'auth_resend'.tr;
  static String get authCompleteProfile => 'auth_complete_profile'.tr;
  static String get authCompleteProfileDesc => 'auth_complete_profile_desc'.tr;
  static String get authCompleteSignup => 'auth_complete_signup'.tr;
  static String get authInviteCodeTip => 'auth_invite_code_tip'.tr;
  static String get authCancelSignup => 'auth_cancel_signup'.tr;
  static String get authCancelSignupDesc => 'auth_cancel_signup_desc'.tr;
  static String get authStay => 'auth_stay'.tr;
  static String get authLeave => 'auth_leave'.tr;
  static String get authLoginSuccess => 'auth_login_success'.tr;
  static String get authSignupSuccess => 'auth_signup_success'.tr;
  static String get authPasswordResetSent => 'auth_password_reset_sent'.tr;
  static String get authLogoutSuccess => 'auth_logout_success'.tr;
  static String get authValidatingInviteCode =>
      'auth_validating_invite_code'.tr;
  static String get authCreatingAccount => 'auth_creating_account'.tr;

  // ==================== Wallet ====================
  static String get wallet => 'wallet'.tr;
  static String get walletBalance => 'wallet_balance'.tr;
  static String get rewardPoints => 'reward_points'.tr;
  static String get availableBalance => 'available_balance'.tr;
  static String get totalEarnings => 'total_earnings'.tr;
  static String get withdraw => 'withdraw'.tr;
  static String get deposit => 'deposit'.tr;
  static String get transfer => 'transfer'.tr;
  static String get convertPoints => 'convert_points'.tr;

  // Transactions
  static String get transactions => 'transactions'.tr;
  static String get transactionHistory => 'transaction_history'.tr;
  static String get noTransactions => 'no_transactions'.tr;
  static String get pending => 'pending'.tr;
  static String get completed => 'completed'.tr;
  static String get failed => 'failed'.tr;
  static String get cancelled => 'cancelled'.tr;

  // Withdrawal
  static String get withdrawFunds => 'withdraw_funds'.tr;
  static String get withdrawTo => 'withdraw_to'.tr;
  static String get enterAmount => 'enter_amount'.tr;
  static String get minWithdraw => 'min_withdraw'.tr;
  static String get withdrawMethod => 'withdraw_method'.tr;
  static String get accountNumber => 'account_number'.tr;
  static String get confirmWithdraw => 'confirm_withdraw'.tr;
  static String get withdrawalSuccess => 'withdrawal_success'.tr;
  static String get insufficientBalance => 'insufficient_balance'.tr;

  // Points Conversion
  static String get convertToBdt => 'convert_to_bdt'.tr;
  static String get pointsToConvert => 'points_to_convert'.tr;
  static String get youWillReceive => 'you_will_receive'.tr;
  static String get conversionRate => 'conversion_rate'.tr;
  static String get minConversion => 'min_conversion'.tr;
  static String get convert => 'convert'.tr;
  static String get conversionSuccess => 'conversion_success'.tr;
  static String get insufficientPoints => 'insufficient_points'.tr;

  // ==================== Rewards ====================
  static String get rewards => 'rewards'.tr;
  static String get earnRewards => 'earn_rewards'.tr;
  static String get yourRewards => 'your_rewards'.tr;
  static String get watchAds => 'watch_ads'.tr;
  static String get watchEarn => 'watch_earn'.tr;
  static String get dailyRewards => 'daily_rewards'.tr;

  // Streak
  static String get streak => 'streak'.tr;
  static String get currentStreak => 'current_streak'.tr;
  static String get longestStreak => 'longest_streak'.tr;
  static String get days => 'days'.tr;
  static String get dayStreak => 'day_streak'.tr;
  static String get keepStreak => 'keep_streak'.tr;
  static String get streakBonus => 'streak_bonus'.tr;
  static String get multiplier => 'multiplier'.tr;

  // Ads
  static String get adsWatchedToday => 'ads_watched_today'.tr;
  static String get pointsEarnedToday => 'points_earned_today'.tr;
  static String get dailyLimit => 'daily_limit'.tr;
  static String get adsRemaining => 'ads_remaining'.tr;
  static String get watchAdEarn => 'watch_ad_earn'.tr;
  static String get adNotReady => 'ad_not_ready'.tr;
  static String get dailyLimitReached => 'daily_limit_reached'.tr;

  // ==================== Recharge ====================
  static String get recharge => 'recharge'.tr;
  static String get mobileRecharge => 'mobile_recharge'.tr;
  static String get rechargeNow => 'recharge_now'.tr;
  static String get enterNumber => 'enter_number'.tr;
  static String get selectOperator => 'select_operator'.tr;
  static String get selectAmount => 'select_amount'.tr;
  static String get customAmount => 'custom_amount'.tr;
  static String get rechargeSuccess => 'recharge_success'.tr;
  static String get rechargeFailed => 'recharge_failed'.tr;

  // ==================== Offers ====================
  static String get offers => 'offers'.tr;
  static String get telecomOffers => 'telecom_offers'.tr;
  static String get hotOffers => 'hot_offers'.tr;
  static String get internetPacks => 'internet_packs'.tr;
  static String get minutePacks => 'minute_packs'.tr;
  static String get comboPacks => 'combo_packs'.tr;
  static String get bundleOffers => 'bundle_offers'.tr;
  static String get validity => 'validity'.tr;
  static String get buyNow => 'buy_now'.tr;

  // ==================== Reselling ====================
  static String get reselling => 'reselling'.tr;
  static String get products => 'products'.tr;
  static String get myOrders => 'my_orders'.tr;
  static String get shareEarn => 'share_earn'.tr;
  static String get productCommission => 'product_commission'.tr;
  static String get orderPlaced => 'order_placed'.tr;
  static String get orderShipped => 'order_shipped'.tr;
  static String get orderDelivered => 'order_delivered'.tr;

  // ==================== Micro Jobs ====================
  static String get microJobs => 'micro_jobs'.tr;
  static String get availableJobs => 'available_jobs'.tr;
  static String get myTasks => 'my_tasks'.tr;
  static String get jobDetails => 'job_details'.tr;
  static String get applyNow => 'apply_now'.tr;
  static String get taskSubmitted => 'task_submitted'.tr;
  static String get earnUpto => 'earn_upto'.tr;

  // ==================== Community ====================
  static String get community => 'community'.tr;
  static String get posts => 'posts'.tr;
  static String get createPost => 'create_post'.tr;
  static String get marketplace => 'marketplace'.tr;
  static String get whatsOnMind => 'whats_on_mind'.tr;
  static String get post => 'post'.tr;
  static String get like => 'like'.tr;
  static String get comment => 'comment'.tr;
  static String get share => 'share'.tr;
  static String get comments => 'comments'.tr;
  static String get writeComment => 'write_comment'.tr;

  // ==================== Profile ====================
  static String get profile => 'profile'.tr;
  static String get editProfile => 'edit_profile'.tr;
  static String get myProfile => 'my_profile'.tr;
  static String get account => 'account'.tr;
  static String get personalInfo => 'personal_info'.tr;
  static String get updateProfile => 'update_profile'.tr;
  static String get profileUpdated => 'profile_updated'.tr;

  // Invite & Referral
  static String get inviteFriends => 'invite_friends'.tr;
  static String get referrals => 'referrals'.tr;
  static String get yourInviteCode => 'your_invite_code'.tr;
  static String get shareInvite => 'share_invite'.tr;
  static String get copyCode => 'copy_code'.tr;
  static String get codeCopied => 'code_copied'.tr;
  static String get totalReferrals => 'total_referrals'.tr;
  static String get referralEarnings => 'referral_earnings'.tr;

  // Settings
  static String get settings => 'settings'.tr;
  static String get notifications => 'notifications'.tr;
  static String get language => 'language'.tr;
  static String get theme => 'theme'.tr;
  static String get about => 'about'.tr;
  static String get helpSupport => 'help_support'.tr;
  static String get privacyPolicy => 'privacy_policy'.tr;
  static String get termsConditions => 'terms_conditions'.tr;
  static String get rateApp => 'rate_app'.tr;
  static String get appVersion => 'app_version'.tr;

  // ==================== Verification ====================
  static String get verifyAccount => 'verify_account'.tr;
  static String get verified => 'verified'.tr;
  static String get notVerified => 'not_verified'.tr;
  static String get completeVerification => 'complete_verification'.tr;
  static String get verificationPending => 'verification_pending'.tr;
  static String get verificationApproved => 'verification_approved'.tr;
  static String get verificationRejected => 'verification_rejected'.tr;

  // ==================== Subscription ====================
  static String get subscription => 'subscription'.tr;
  static String get premium => 'premium'.tr;
  static String get subscribeNow => 'subscribe_now'.tr;
  static String get subscribed => 'subscribed'.tr;
  static String get subscriptionBenefits => 'subscription_benefits'.tr;
  static String get subscriptionExpires => 'subscription_expires'.tr;

  // ==================== Error Messages ====================
  static String get networkError => 'network_error'.tr;
  static String get somethingWentWrong => 'something_went_wrong'.tr;
  static String get sessionExpired => 'session_expired'.tr;
  static String get permissionDenied => 'permission_denied'.tr;
  static String get featureLocked => 'feature_locked'.tr;

  // ==================== Success Messages ====================
  static String get success => 'success'.tr;
  static String get savedSuccessfully => 'saved_successfully'.tr;
  static String get updatedSuccessfully => 'updated_successfully'.tr;
  static String get deletedSuccessfully => 'deleted_successfully'.tr;

  // ==================== UI Actions ====================
  static String get toggleTheme => 'toggle_theme'.tr;
  static String get toggleLanguage => 'toggle_language'.tr;
  static String get themeChanged => 'theme_changed'.tr;
  static String get darkThemeEnabled => 'dark_theme_enabled'.tr;
  static String get lightThemeEnabled => 'light_theme_enabled'.tr;
  static String get languageChanged => 'language_changed'.tr;

  // ==================== Payment ====================
  static String get payment => 'payment'.tr;
  static String get paymentMethod => 'payment_method'.tr;
  static String get selectPaymentMethod => 'select_payment_method'.tr;
  static String get payNow => 'pay_now'.tr;
  static String get paymentSuccessful => 'payment_successful'.tr;
  static String get paymentFailed => 'payment_failed'.tr;
  static String get paymentCancelled => 'payment_cancelled'.tr;
  static String get processingPayment => 'processing_payment'.tr;

  // ==================== Onboarding Screens ====================
  static String get obWelcomeTitle => 'ob_welcome_title'.tr;
  static String get obWelcomeSubtitle => 'ob_welcome_subtitle'.tr;
  static String get obWelcomeDesc => 'ob_welcome_desc'.tr;
  static String get obHowWorksTitle => 'ob_how_works_title'.tr;
  static String get obHowWorksSubtitle => 'ob_how_works_subtitle'.tr;
  static String get obHowWorksDesc => 'ob_how_works_desc'.tr;
  static String get obTransparencyTitle => 'ob_transparency_title'.tr;
  static String get obTransparencySubtitle => 'ob_transparency_subtitle'.tr;
  static String get obTransparencyDesc => 'ob_transparency_desc'.tr;
  static String get obFeaturesTitle => 'ob_features_title'.tr;
  static String get obFeaturesSubtitle => 'ob_features_subtitle'.tr;
  static String get obFeature1 => 'ob_feature_1'.tr;
  static String get obFeature2 => 'ob_feature_2'.tr;
  static String get obFeature3 => 'ob_feature_3'.tr;
  static String get obFeature4 => 'ob_feature_4'.tr;
  static String get obFeature5 => 'ob_feature_5'.tr;
  static String get obFeature6 => 'ob_feature_6'.tr;
  static String get obFeature7 => 'ob_feature_7'.tr;
  static String get obFeature8 => 'ob_feature_8'.tr;
  static String get obFeature9 => 'ob_feature_9'.tr;
  static String get obFeature10 => 'ob_feature_10'.tr;
  static String get obFeature11 => 'ob_feature_11'.tr;
  static String get obFeature12 => 'ob_feature_12'.tr;
}
