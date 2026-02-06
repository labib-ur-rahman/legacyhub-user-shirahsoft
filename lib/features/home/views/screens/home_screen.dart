import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:legacyhub/core/utils/constants/app_style_colors.dart';
import 'package:legacyhub/features/home/controllers/home_controller.dart';
import 'package:legacyhub/features/home/views/widgets/ads/ads_view_card.dart';
import 'package:legacyhub/features/home/views/widgets/community_post/community_post_card.dart';
import 'package:legacyhub/features/home/views/widgets/create_post/create_post_section.dart';
import 'package:legacyhub/features/home/views/widgets/drive_offers/drive_offers_section.dart';
import 'package:legacyhub/features/home/views/widgets/micro_job/micro_job_card.dart';
import 'package:legacyhub/features/home/views/widgets/on_demand_post/on_demand_post_card.dart';
import 'package:legacyhub/features/home/views/widgets/people_you_may_know/people_you_may_know_section.dart';
import 'package:legacyhub/features/home/views/widgets/quick_actions/quick_actions_section.dart';
import 'package:legacyhub/features/home/views/widgets/resell_product/resell_product_card.dart';
import 'package:legacyhub/features/home/views/widgets/sell_item_post/sell_item_post_card.dart';

/// Home Screen - Facebook-style infinite scroll feed
/// Contains: CreatePost, QuickActions, and various post cards
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final colors = AppStyleColors.instance;

    // Get controller instance
    final controller = HomeController.instance;

    return Container(
      color: isDark ? const Color(0xFF121218) : const Color(0xFFF5F5F5),
      child: RefreshIndicator(
        color: colors.primary,
        onRefresh: () async {
          // TODO: Implement refresh logic
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          itemCount: _feedItems.length,
          itemBuilder: (context, index) {
            final item = _feedItems[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _buildFeedItem(item, isDark, colors),
            );
          },
        ),
      ),
    );
  }

  /// Build feed item based on type
  Widget _buildFeedItem(FeedItem item, bool isDark, AppStyleColors colors) {
    switch (item.type) {
      case FeedItemType.createPost:
        return const CreatePostSection();

      case FeedItemType.quickActions:
        return const QuickActionsSection();

      case FeedItemType.communityPost:
        return CommunityPostCard(
          userName: item.data['userName'] as String,
          userAvatar: item.data['userAvatar'] as String,
          timeAgo: item.data['timeAgo'] as String,
          content: item.data['content'] as String,
          imageUrl: item.data['imageUrl'] as String?,
          likes: item.data['likes'] as int? ?? 0,
          comments: item.data['comments'] as int? ?? 0,
          hasImage: item.data['hasImage'] as bool? ?? true,
        );

      case FeedItemType.microJob:
        return MicroJobCard(
          jobTitle: item.data['jobTitle'] as String,
          description: item.data['description'] as String,
          imageUrl: item.data['imageUrl'] as String?,
          taskLink: item.data['taskLink'] as String?,
          perTaskAmount: item.data['perTaskAmount'] as String? ?? '1\$',
          completedTasks: item.data['completedTasks'] as int? ?? 230,
          totalTasks: item.data['totalTasks'] as int? ?? 500,
        );

      case FeedItemType.resellProduct:
        return ResellProductCard(
          productTitle: item.data['productTitle'] as String,
          productImage: item.data['productImage'] as String,
          originalPrice: item.data['originalPrice'] as String,
          resellerPrice: item.data['resellerPrice'] as String,
          profit: item.data['profit'] as String,
          sellerName: item.data['sellerName'] as String,
          sellerAvatar: item.data['sellerAvatar'] as String,
          rating: item.data['rating'] as double? ?? 4.5,
          soldCount: item.data['soldCount'] as int? ?? 0,
          isFeatured: item.data['isFeatured'] as bool? ?? false,
        );

      case FeedItemType.driveOffers:
        return const DriveOffersSection();

      case FeedItemType.peopleYouMayKnow:
        return const PeopleYouMayKnowSection();

      case FeedItemType.onDemandPost:
        return OnDemandPostCard(
          userName: item.data['userName'] as String,
          userAvatar: item.data['userAvatar'] as String,
          timeAgo: item.data['timeAgo'] as String,
          requestTitle: item.data['requestTitle'] as String,
          description: item.data['description'] as String,
          category: item.data['category'] as String,
          budget: item.data['budget'] as String,
          location: item.data['location'] as String,
          responseCount: item.data['responseCount'] as int? ?? 0,
        );

      case FeedItemType.sellItemPost:
        return SellItemPostCard(
          userName: item.data['userName'] as String,
          userAvatar: item.data['userAvatar'] as String,
          timeAgo: item.data['timeAgo'] as String,
          itemTitle: item.data['itemTitle'] as String,
          description: item.data['description'] as String,
          price: item.data['price'] as String,
          condition: item.data['condition'] as String,
          location: item.data['location'] as String,
          images: (item.data['images'] as List?)?.cast<String>() ?? [],
          isNegotiable: item.data['isNegotiable'] as bool? ?? false,
        );

      case FeedItemType.adsView:
        return AdsViewCard(
          sponsorName: item.data['sponsorName'] as String,
          sponsorLogo: item.data['sponsorLogo'] as String,
          adImage: item.data['adImage'] as String,
          adTitle: item.data['adTitle'] as String,
          adDescription: item.data['adDescription'] as String,
          ctaText: item.data['ctaText'] as String,
          ctaUrl: item.data['ctaUrl'] as String? ?? '',
        );
    }
  }
}

/// Feed item types
enum FeedItemType {
  createPost,
  quickActions,
  communityPost,
  microJob,
  resellProduct,
  driveOffers,
  peopleYouMayKnow,
  onDemandPost,
  sellItemPost,
  adsView,
}

/// Feed item model
class FeedItem {
  const FeedItem({required this.type, this.data = const {}});

  final FeedItemType type;
  final Map<String, dynamic> data;
}

/// Demo feed items for testing UI
final List<FeedItem> _feedItems = [
  // Static sections at top
  const FeedItem(type: FeedItemType.createPost),
  const FeedItem(type: FeedItemType.quickActions),

  // Community Post
  const FeedItem(
    type: FeedItemType.communityPost,
    data: {
      'userName': 'Rahim Ahmed',
      'userAvatar': 'https://picsum.photos/100/100?random=30',
      'timeAgo': '2 hours ago',
      'content':
          'Just launched my new reselling business on LegacyHub! Excited to start this journey. Anyone else doing reselling here? Let\'s connect! 🚀',
      'imageUrl': 'https://picsum.photos/500/400?random=31',
      'likes': 42,
      'comments': 8,
      'hasImage': true,
    },
  ),

  // Micro Job Card
  const FeedItem(
    type: FeedItemType.microJob,
    data: {
      'jobTitle': 'Facebook Page Like & Comment',
      'description':
          'Like our Facebook page and leave a genuine comment about our products',
      'imageUrl': 'https://picsum.photos/600/400?random=32',
      'taskLink': 'https://facebook.com/our-page',
      'perTaskAmount': '1\$',
      'completedTasks': 230,
      'totalTasks': 500,
    },
  ),

  // Drive Offers Section
  const FeedItem(type: FeedItemType.driveOffers),

  // Resell Product Card
  const FeedItem(
    type: FeedItemType.resellProduct,
    data: {
      'productTitle': 'Premium Wireless Earbuds - Noise Cancellation',
      'productImage': 'https://picsum.photos/500/400?random=33',
      'originalPrice': '৳2,500',
      'resellerPrice': '৳1,800',
      'profit': '৳200-৳400',
      'sellerName': 'TechStore BD',
      'sellerAvatar': 'https://picsum.photos/100/100?random=34',
      'rating': 4.7,
      'soldCount': 156,
      'isFeatured': true,
    },
  ),

  // People You May Know Section
  const FeedItem(type: FeedItemType.peopleYouMayKnow),

  // Community Post (another)
  const FeedItem(
    type: FeedItemType.communityPost,
    data: {
      'userName': 'Fatima Begum',
      'userAvatar': 'https://picsum.photos/100/100?random=35',
      'timeAgo': '4 hours ago',
      'content':
          'Tips for earning more reward points on LegacyHub:\n\n1. Watch ads daily ✅\n2. Keep your streak going 🔥\n3. Refer friends 👥\n4. Complete micro jobs 💼\n\nWhat other tips do you have?',
      'likes': 89,
      'comments': 24,
      'hasImage': false,
    },
  ),

  // On-Demand Post
  const FeedItem(
    type: FeedItemType.onDemandPost,
    data: {
      'userName': 'Nasir Islam',
      'userAvatar': 'https://picsum.photos/100/100?random=36',
      'timeAgo': '1 hour ago',
      'requestTitle': 'Looking for iPhone 14 Pro Max',
      'description':
          'Need iPhone 14 Pro Max 256GB in good condition. Preferably with box and charger. Can meet in Dhaka for purchase.',
      'category': 'Electronics',
      'budget': '৳85,000',
      'location': 'Dhaka',
      'responseCount': 5,
    },
  ),

  // Ads Card
  const FeedItem(
    type: FeedItemType.adsView,
    data: {
      'sponsorName': 'GP 5G Internet',
      'sponsorLogo': 'https://picsum.photos/100/100?random=37',
      'adImage': 'https://picsum.photos/500/300?random=38',
      'adTitle': 'Experience Lightning Fast 5G',
      'adDescription':
          'Switch to GP 5G and enjoy speeds up to 10x faster. Limited time offer: Get 10GB bonus on first recharge!',
      'ctaText': 'Get Offer Now',
      'ctaUrl': 'https://example.com/gp5g',
    },
  ),

  // Sell Item Post
  const FeedItem(
    type: FeedItemType.sellItemPost,
    data: {
      'userName': 'Salma Khatun',
      'userAvatar': 'https://picsum.photos/100/100?random=39',
      'timeAgo': '30 minutes ago',
      'itemTitle': 'Samsung Galaxy S23 Ultra - Like New',
      'description':
          '8 months old Samsung Galaxy S23 Ultra 256GB. No scratches, comes with original box, charger, and back cover. Selling because upgrading to a new phone.',
      'price': '৳95,000',
      'condition': 'Like New',
      'location': 'Chattogram',
      'images': [
        'https://picsum.photos/400/400?random=40',
        'https://picsum.photos/400/400?random=41',
        'https://picsum.photos/400/400?random=42',
      ],
      'isNegotiable': true,
    },
  ),

  // Micro Job Card (another)
  const FeedItem(
    type: FeedItemType.microJob,
    data: {
      'jobTitle': 'Social Media Engagement Task',
      'description':
          'Follow our Instagram account and like 10 recent posts. Share one story mention.',
      'imageUrl': 'https://picsum.photos/600/400?random=43',
      'taskLink': 'https://instagram.com/our-account',
      'perTaskAmount': '2\$',
      'completedTasks': 150,
      'totalTasks': 300,
    },
  ),

  // Resell Product Card (another)
  const FeedItem(
    type: FeedItemType.resellProduct,
    data: {
      'productTitle': 'Smart Watch Series 8 - Fitness Tracker',
      'productImage': 'https://picsum.photos/500/400?random=44',
      'originalPrice': '৳4,500',
      'resellerPrice': '৳3,200',
      'profit': '৳300-৳500',
      'sellerName': 'WatchZone BD',
      'sellerAvatar': 'https://picsum.photos/100/100?random=45',
      'rating': 4.5,
      'soldCount': 89,
      'isFeatured': false,
    },
  ),

  // Community Post (another)
  const FeedItem(
    type: FeedItemType.communityPost,
    data: {
      'userName': 'Jahid Hasan',
      'userAvatar': 'https://picsum.photos/100/100?random=46',
      'timeAgo': '6 hours ago',
      'content':
          'Just received my first withdrawal from LegacyHub wallet! The process was smooth and quick. Thanks to the team for making this possible! 💰',
      'imageUrl': 'https://picsum.photos/500/400?random=47',
      'likes': 124,
      'comments': 32,
      'hasImage': true,
    },
  ),
];
