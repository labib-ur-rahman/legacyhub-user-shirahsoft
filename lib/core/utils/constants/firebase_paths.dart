/// Firebase Paths - Centralized Firebase collection and document paths
/// All Firebase path references must use this class
class FirebasePaths {
  FirebasePaths._();

  // ==================== Collections ====================

  /// Users collection - Core user documents
  static const String users = 'users';

  /// Invite codes collection - Unique invite code index
  static const String inviteCodes = 'invite_codes';

  /// Wallets collection - Detailed wallet data
  static const String wallets = 'wallets';

  /// Transactions collection - All financial transactions
  static const String transactions = 'transactions';

  /// Reward logs collection - Reward point history
  static const String rewardLogs = 'reward_logs';

  /// Streaks collection - User streak data
  static const String streaks = 'streaks';

  /// Posts collection - Community posts
  static const String posts = 'posts';

  /// Comments subcollection name
  static const String comments = 'comments';

  /// Marketplace collection - Buy & sell items
  static const String marketplace = 'marketplace';

  /// Micro jobs collection
  static const String microJobs = 'micro_jobs';

  /// Job submissions subcollection
  static const String jobSubmissions = 'submissions';

  /// Products collection - Reselling products
  static const String products = 'products';

  /// Telecom offers collection
  static const String telecomOffers = 'telecom_offers';

  /// Notifications collection
  static const String notifications = 'notifications';

  /// Withdrawal requests collection
  static const String withdrawalRequests = 'withdrawal_requests';

  /// Recharge history collection
  static const String rechargeHistory = 'recharge_history';

  /// Vouchers collection
  static const String vouchers = 'vouchers';

  /// User vouchers subcollection
  static const String userVouchers = 'user_vouchers';

  // ==================== Document References ====================

  /// Get user document path
  static String user(String uid) => '$users/$uid';

  /// Get invite code document path
  static String inviteCode(String code) => '$inviteCodes/$code';

  /// Get wallet document path
  static String wallet(String uid) => '$wallets/$uid';

  /// Get streak document path
  static String streak(String uid) => '$streaks/$uid';

  /// Get transaction document path
  static String transaction(String transactionId) =>
      '$transactions/$transactionId';

  /// Get post document path
  static String post(String postId) => '$posts/$postId';

  /// Get marketplace item document path
  static String marketplaceItem(String itemId) => '$marketplace/$itemId';

  /// Get micro job document path
  static String microJob(String jobId) => '$microJobs/$jobId';

  /// Get product document path
  static String product(String productId) => '$products/$productId';

  /// Get notification document path
  static String notification(String notificationId) =>
      '$notifications/$notificationId';

  // ==================== Subcollection References ====================

  /// Get post comments subcollection path
  static String postComments(String postId) => '$posts/$postId/$comments';

  /// Get job submissions subcollection path
  static String microJobSubmissions(String jobId) =>
      '$microJobs/$jobId/$jobSubmissions';

  /// Get user notifications subcollection path
  static String userNotifications(String uid) => '$users/$uid/$notifications';

  /// Get user transactions subcollection path
  static String userTransactions(String uid) => '$users/$uid/$transactions';

  // ==================== Realtime Database Paths ====================

  /// Online status path in Realtime Database
  static String onlineStatus(String uid) => 'status/$uid';

  /// Typing indicators path
  static String typingIndicator(String chatId, String uid) =>
      'typing/$chatId/$uid';

  // ==================== Storage Paths ====================

  /// User avatar storage path
  static String userAvatar(String uid) => 'avatars/$uid';

  /// Post images storage path
  static String postImage(String postId, String imageId) =>
      'posts/$postId/$imageId';

  /// Marketplace item images storage path
  static String marketplaceImage(String itemId, String imageId) =>
      'marketplace/$itemId/$imageId';

  /// NID verification images storage path
  static String nidImage(String uid, String side) =>
      'nid_verification/$uid/$side';

  /// Job proof images storage path
  static String jobProof(String jobId, String submissionId) =>
      'job_proofs/$jobId/$submissionId';
}
