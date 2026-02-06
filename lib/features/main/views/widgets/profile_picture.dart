import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:legacyhub/core/utils/helpers/app_helper.dart';

/// Profile picture widget with circular shape and cached image
/// Used in main tab bar for the Profile tab
class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
    this.onTap,
    this.height,
    this.width,
    this.imageUrl,
    this.showBorder = true,
    this.isActive = false,
  });

  final VoidCallback? onTap;
  final double? height;
  final double? width;
  final String? imageUrl;
  final bool showBorder;
  final bool isActive;

  /// Default profile image URL
  static const String defaultProfileUrl =
      'https://avatars.githubusercontent.com/u/177158869';

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);
    final size = height ?? 24.w;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isActive ? size + 2 : size,
        height: isActive ? size + 2 : size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: showBorder ? Border.all(color: Colors.white, width: 1) : null,
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl ?? defaultProfileUrl,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              highlightColor: isDark ? Colors.grey[500]! : Colors.grey[100]!,
              child: Container(color: Colors.white),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[400],
              child: Icon(Icons.person, color: Colors.white, size: size * 0.6),
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
