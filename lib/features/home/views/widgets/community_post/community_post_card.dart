import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:animated_emoji/animated_emoji.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';

/// Community Post Card - User post with profile, content, image, and reactions
/// Displays: User avatar, name, time, content text, image, reactions (like, comment, share)
/// Design matches Figma: Clean card with proper spacing, full-width image
/// Features: Animated emoji reaction popup on long press of like button
class CommunityPostCard extends StatefulWidget {
  const CommunityPostCard({
    super.key,
    required this.userName,
    required this.userAvatar,
    required this.timeAgo,
    required this.content,
    this.imageUrl,
    this.likes = 0,
    this.comments = 0,
    this.hasImage = true,
    this.onReactionSelected,
  });

  final String userName;
  final String userAvatar;
  final String timeAgo;
  final String content;
  final String? imageUrl;
  final int likes;
  final int comments;
  final bool hasImage;
  final Function(String reactionType)? onReactionSelected;

  @override
  State<CommunityPostCard> createState() => _CommunityPostCardState();
}

class _CommunityPostCardState extends State<CommunityPostCard>
    with SingleTickerProviderStateMixin {
  /// Overlay entry for reaction popup
  OverlayEntry? _overlayEntry;

  /// Key for the like button to get its position
  final GlobalKey _likeButtonKey = GlobalKey();

  /// Currently selected reaction (null = no reaction)
  String? _selectedReaction;

  /// Animation controller for popup
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    _animationController.dispose();
    super.dispose();
  }

  /// Show the reaction popup above the like button
  void _showReactionPopup() {
    _removeOverlay();

    final RenderBox? renderBox =
        _likeButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final Offset position = renderBox.localToGlobal(Offset.zero);
    // final Size size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          /// Dismiss area - tap anywhere to close
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          ),

          /// Reaction popup
          Positioned(
            left: position.dx - 20.w,
            top: position.dy - 70.h,
            child: ScaleTransition(
              scale: _scaleAnimation,
              alignment: Alignment.bottomLeft,
              child: _buildReactionPopup(),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
  }

  /// Remove the overlay
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _animationController.reset();
  }

  /// Build the reaction popup container
  Widget _buildReactionPopup() {
    final isDark = Get.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A3E) : Colors.white,
        borderRadius: BorderRadius.circular(50.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildReactionItem(
            emoji: AnimatedEmojis.thumbsUp,
            label: 'Like',
            color: const Color(0xFF2563EB),
          ),
          SizedBox(width: 8.w),
          _buildReactionItem(
            emoji: AnimatedEmojis.redHeart,
            label: 'Love',
            color: const Color(0xFFE11D48),
          ),
          SizedBox(width: 8.w),
          _buildReactionItem(
            emoji: AnimatedEmojis.heartFace,
            label: 'Care',
            color: const Color(0xFFF59E0B),
          ),
          SizedBox(width: 8.w),
          _buildReactionItem(
            emoji: AnimatedEmojis.joy,
            label: 'Haha',
            color: const Color(0xFFF59E0B),
          ),
          SizedBox(width: 8.w),
          _buildReactionItem(
            emoji: AnimatedEmojis.mouthOpen,
            label: 'Wow',
            color: const Color(0xFFF59E0B),
          ),
          SizedBox(width: 8.w),
          _buildReactionItem(
            emoji: AnimatedEmojis.cry,
            label: 'Sad',
            color: const Color(0xFFF59E0B),
          ),
          SizedBox(width: 8.w),
          _buildReactionItem(
            emoji: AnimatedEmojis.rage,
            label: 'Angry',
            color: const Color(0xFFEA580C),
          ),
        ],
      ),
    );
  }

  /// Build individual reaction item
  Widget _buildReactionItem({
    required AnimatedEmojiData emoji,
    required String label,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedReaction = label;
        });
        widget.onReactionSelected?.call(label);
        _removeOverlay();
      },
      child: AnimatedEmoji(emoji, size: 32.sp, repeat: true),
    );
  }

  /// Get the icon and color based on selected reaction
  Widget _buildLikeButtonContent(bool isDark) {
    if (_selectedReaction == null) {
      return Icon(
        Iconsax.like_1,
        size: 16.sp,
        color: isDark ? Colors.white54 : const Color(0xFF364153),
      );
    }

    switch (_selectedReaction) {
      case 'Like':
        return Icon(
          Iconsax.like_15,
          size: 16.sp,
          color: const Color(0xFF2563EB),
        );
      case 'Love':
        return Text('❤️', style: TextStyle(fontSize: 14.sp));
      case 'Care':
        return Text('🥰', style: TextStyle(fontSize: 14.sp));
      case 'Haha':
        return Text('😂', style: TextStyle(fontSize: 14.sp));
      case 'Wow':
        return Text('😮', style: TextStyle(fontSize: 14.sp));
      case 'Sad':
        return Text('😢', style: TextStyle(fontSize: 14.sp));
      case 'Angry':
        return Text('😠', style: TextStyle(fontSize: 14.sp));
      default:
        return Icon(
          Iconsax.like_1,
          size: 16.sp,
          color: isDark ? Colors.white54 : const Color(0xFF364153),
        );
    }
  }

  /// Get the text color based on selected reaction
  Color _getLikeTextColor(bool isDark) {
    if (_selectedReaction == null) {
      return isDark ? Colors.white54 : const Color(0xFF364153);
    }

    switch (_selectedReaction) {
      case 'Like':
        return const Color(0xFF2563EB);
      case 'Love':
        return const Color(0xFFE11D48);
      case 'Care':
        return const Color(0xFFF59E0B);
      case 'Haha':
        return const Color(0xFFF59E0B);
      case 'Wow':
        return const Color(0xFFF59E0B);
      case 'Sad':
        return const Color(0xFFF59E0B);
      case 'Angry':
        return const Color(0xFFEA580C);
      default:
        return isDark ? Colors.white54 : const Color(0xFF364153);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// -- Header: User info
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                /// -- Avatar
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(widget.userAvatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                /// -- Name & Time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// -- User Name
                      Text(
                        widget.userName,
                        style: getBoldTextStyle(
                          fontSize: 16,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1E2939),
                        ),
                      ),

                      /// -- Time & Globe
                      Row(
                        children: [
                          Text(
                            widget.timeAgo,
                            style: getTextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.white54
                                  : const Color(0xFF6A7282),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            '•',
                            style: getTextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.white54
                                  : const Color(0xFF6A7282),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Icon(
                            Iconsax.global,
                            size: 14.sp,
                            color: isDark
                                ? Colors.white54
                                : const Color(0xFF6A7282),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// -- More Button (Vertical dots)
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 28.w,
                    height: 28.h,
                    alignment: Alignment.center,
                    child: Icon(
                      Iconsax.more,
                      size: 20.sp,
                      color: isDark ? Colors.white54 : const Color(0xFF6A7282),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// -- Content Text
          if (widget.content.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                widget.content,
                style: getTextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white : const Color(0xFF364153),
                ),
              ),
            ),

          if (widget.content.isNotEmpty &&
              widget.hasImage &&
              widget.imageUrl != null)
            SizedBox(height: 12.h),

          /// -- Post Image (Full width, no border radius)
          if (widget.hasImage && widget.imageUrl != null)
            CachedNetworkImage(
              imageUrl: widget.imageUrl!,
              width: double.infinity,
              height: 263.h,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: double.infinity,
                height: 263.h,
                color: isDark ? const Color(0xFF2A2A3E) : Colors.grey.shade200,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: isDark ? Colors.white38 : Colors.grey,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: double.infinity,
                height: 263.h,
                color: isDark ? const Color(0xFF2A2A3E) : Colors.grey.shade200,
                child: Icon(
                  Iconsax.image,
                  size: 40.sp,
                  color: isDark ? Colors.white38 : Colors.grey,
                ),
              ),
            ),

          /// -- Reactions Row
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : const Color(0xFFF3F4F6),
                  width: 1.3,
                ),
              ),
            ),
            child: Row(
              children: [
                /// -- Like Button with Reaction Popup
                GestureDetector(
                  key: _likeButtonKey,
                  onTap: () {
                    // Quick tap toggles like
                    if (_selectedReaction == null) {
                      setState(() {
                        _selectedReaction = 'Like';
                      });
                      widget.onReactionSelected?.call('Like');
                    } else {
                      setState(() {
                        _selectedReaction = null;
                      });
                    }
                  },
                  onLongPress: _showReactionPopup,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLikeButtonContent(isDark),
                      if (widget.likes > 0 || _selectedReaction != null) ...[
                        SizedBox(width: 6.w),
                        Text(
                          _selectedReaction != null
                              ? (widget.likes + 1).toString()
                              : widget.likes.toString(),
                          style: getTextStyle(
                            fontSize: 14,
                            color: _getLikeTextColor(isDark),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 16.w),

                /// -- Comment Button
                _buildReactionButton(
                  icon: Iconsax.message,
                  count: widget.comments,
                  isDark: isDark,
                ),
                SizedBox(width: 16.w),

                /// -- Share Button
                _buildReactionButton(icon: Iconsax.share, isDark: isDark),

                const Spacer(),

                /// -- Emoji Reactions Display
                Row(
                  children: [
                    Text('❤️', style: TextStyle(fontSize: 16.sp)),
                    Text('🥰', style: TextStyle(fontSize: 16.sp)),
                    Text('👍', style: TextStyle(fontSize: 16.sp)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build reaction button with icon and count
  Widget _buildReactionButton({
    required IconData icon,
    int? count,
    required bool isDark,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: isDark ? Colors.white54 : const Color(0xFF364153),
        ),
        if (count != null && count > 0) ...[
          SizedBox(width: 6.w),
          Text(
            count.toString(),
            style: getTextStyle(
              fontSize: 14,
              color: isDark ? Colors.white54 : const Color(0xFF364153),
            ),
          ),
        ],
      ],
    );
  }
}
