import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:legacyhub/features/main/views/widgets/profile_picture.dart';

/// Profile tab icon widget - Uses network image instead of SVG
/// Shows user's profile picture in the tab bar
/// Fixed at 24px size per design specification
class ProfileTabIcon extends StatelessWidget {
  const ProfileTabIcon({super.key, required this.isActive, this.imageUrl});

  final bool isActive;
  final String? imageUrl;

  /// Fixed icon size for all states (25px)
  static const double iconSize = 25;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: ProfilePicture(
        height: iconSize.w,
        width: iconSize.w,
        imageUrl: imageUrl,
        showBorder: true,
        isActive: isActive,
      ),
    );
  }
}
