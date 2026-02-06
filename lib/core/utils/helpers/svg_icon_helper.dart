import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIconHelper {
  SvgIconHelper._();

  static Widget buildIcon({
    required String assetPath,
    double? width,
    double? height,
    Color? color,
    BoxFit fit = BoxFit.contain,
    VoidCallback? onTap,
  }) {
    return SvgPicture.asset(
      assetPath,
      width: width ?? 24.w,
      height: height ?? 24.h,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
      fit: fit,
    );
  }

  // Enhanced version with tap handler
  static Widget buildIconWithTap({
    required String assetPath,
    double? width,
    double? height,
    Color? color,
    VoidCallback? onTap,
    BoxFit fit = BoxFit.contain,
  }) {
    final iconWidget = buildIcon(
      assetPath: assetPath,
      width: width ?? 24.w,
      height: height ?? 24.h,
      color: color,
      fit: fit,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: iconWidget);
    }

    return iconWidget;
  }
}
