import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIconHelper {
  SvgIconHelper._();

  static Widget buildIcon({
    required String assetPath,
    double? size,
    Color? color,
    BoxFit fit = BoxFit.contain,
    VoidCallback? onTap,
  }) {
    return SvgPicture.asset(
      assetPath,
      width: size ?? 24.w,
      height: size ?? 24.h,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
      fit: fit,
    );
  }

  // Enhanced version with tap handler
  static Widget buildIconWithTap({
    required String assetPath,
    double? size,
    Color? color,
    VoidCallback? onTap,
    BoxFit fit = BoxFit.contain,
  }) {
    final iconWidget = buildIcon(
      assetPath: assetPath,
      size: size ?? 24.w,
      color: color,
      fit: fit,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: iconWidget);
    }

    return iconWidget;
  }
}
