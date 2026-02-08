/// App Routes - Contains all route names used in LegacyHub
/// This centralizes route names and prevents typos
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  // ==================== Core Routes ====================
  /// Splash screen route - Initial loading screen
  static const String SPLASH = '/splash';

  /// Home screen route - Main dashboard/landing page
  static const String HOME = '/home';

  /// Main screen route - Main app navigation with bottom nav
  static const String MAIN = '/main';

  // ==================== Onboarding Routes ====================
  /// Main onboarding flow (4 screens)
  static const String ONBOARDING = '/onboarding';

  /// Theme selection during onboarding
  static const String THEME_SELECTION = '/theme-selection';

  /// Language selection during onboarding
  static const String LANGUAGE_SELECTION = '/language-selection';

  /// Style selection during onboarding
  static const String STYLE_SELECTION = '/style-selection';

  // ==================== Authentication Routes ====================
  /// Login screen route
  static const String LOGIN = '/login';

  /// Signup screen route
  static const String SIGNUP = '/signup';

  /// Forgot password screen route
  static const String FORGOT_PASSWORD = '/forgot-password';

  /// Check email screen route (after forgot password)
  static const String CHECK_EMAIL = '/check-email';

  /// Invite code screen route (Google signup completion)
  static const String INVITE_CODE = '/invite-code';

  /// OTP verification screen
  static const String OTP_VERIFICATION = '/otp-verification';

  /// Profile setup (for new users)
  static const String PROFILE_SETUP = '/profile-setup';

  // ==================== Wallet Routes ====================
  /// Wallet main screen
  static const String WALLET = '/wallet';

  /// Transaction history
  static const String TRANSACTIONS = '/transactions';

  /// Withdraw screen
  static const String WITHDRAW = '/withdraw';

  /// Points conversion screen
  static const String CONVERT_POINTS = '/convert-points';

  // ==================== Rewards Routes ====================
  /// Rewards main screen
  static const String REWARDS = '/rewards';

  /// Watch ads screen
  static const String WATCH_ADS = '/watch-ads';

  /// Streak details
  static const String STREAK = '/streak';

  // ==================== Services Routes ====================
  /// Mobile recharge
  static const String RECHARGE = '/recharge';

  /// Telecom offers
  static const String OFFERS = '/offers';

  /// Offer details
  static const String OFFER_DETAILS = '/offer-details';

  // ==================== Reselling Routes ====================
  /// Reselling home
  static const String RESELLING = '/reselling';

  /// Product catalog
  static const String PRODUCTS = '/products';

  /// Product details
  static const String PRODUCT_DETAILS = '/product-details';

  /// My orders
  static const String MY_ORDERS = '/my-orders';

  // ==================== Micro Jobs Routes ====================
  /// Micro jobs listing
  static const String MICRO_JOBS = '/micro-jobs';

  /// Job details
  static const String JOB_DETAILS = '/job-details';

  /// My tasks
  static const String MY_TASKS = '/my-tasks';

  // ==================== Community Routes ====================
  /// Community feed
  static const String COMMUNITY = '/community';

  /// Create post
  static const String CREATE_POST = '/create-post';

  /// Marketplace
  static const String MARKETPLACE = '/marketplace';

  // ==================== Profile Routes ====================
  /// User profile
  static const String PROFILE = '/profile';

  /// Edit profile
  static const String EDIT_PROFILE = '/edit-profile';

  /// Referrals / Invite friends
  static const String REFERRALS = '/referrals';

  /// Settings
  static const String SETTINGS = '/settings';

  /// Notifications
  static const String NOTIFICATIONS = '/notifications';

  // ==================== Route Getters ====================
  // Core
  static String getSplashScreen() => SPLASH;
  static String getHomeScreen() => HOME;
  static String getMainScreen() => MAIN;

  // Onboarding
  static String getThemeScreen() => THEME_SELECTION;
  static String getLanguageScreen() => LANGUAGE_SELECTION;
  static String getStyleScreen() => STYLE_SELECTION;

  // Auth
  static String getLoginScreen() => LOGIN;
  static String getSignupScreen() => SIGNUP;
  static String getForgotPasswordScreen() => FORGOT_PASSWORD;
  static String getCheckEmailScreen() => CHECK_EMAIL;
  static String getInviteCodeScreen() => INVITE_CODE;
  static String getOtpScreen() => OTP_VERIFICATION;
  static String getProfileSetupScreen() => PROFILE_SETUP;

  // Wallet
  static String getWalletScreen() => WALLET;
  static String getTransactionsScreen() => TRANSACTIONS;
  static String getWithdrawScreen() => WITHDRAW;
  static String getConvertPointsScreen() => CONVERT_POINTS;

  // Rewards
  static String getRewardsScreen() => REWARDS;
  static String getWatchAdsScreen() => WATCH_ADS;
  static String getStreakScreen() => STREAK;

  // Services
  static String getRechargeScreen() => RECHARGE;
  static String getOffersScreen() => OFFERS;
  static String getOfferDetailsScreen() => OFFER_DETAILS;

  // Reselling
  static String getResellingScreen() => RESELLING;
  static String getProductsScreen() => PRODUCTS;
  static String getProductDetailsScreen() => PRODUCT_DETAILS;
  static String getMyOrdersScreen() => MY_ORDERS;

  // Micro Jobs
  static String getMicroJobsScreen() => MICRO_JOBS;
  static String getJobDetailsScreen() => JOB_DETAILS;
  static String getMyTasksScreen() => MY_TASKS;

  // Community
  static String getCommunityScreen() => COMMUNITY;
  static String getCreatePostScreen() => CREATE_POST;
  static String getMarketplaceScreen() => MARKETPLACE;

  // Profile
  static String getProfileScreen() => PROFILE;
  static String getEditProfileScreen() => EDIT_PROFILE;
  static String getReferralsScreen() => REFERRALS;
  static String getSettingsScreen() => SETTINGS;
  static String getNotificationsScreen() => NOTIFICATIONS;
}
