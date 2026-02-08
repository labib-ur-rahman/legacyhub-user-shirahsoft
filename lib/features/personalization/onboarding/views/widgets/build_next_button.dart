import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:legacyhub/core/utils/constants/svg_path.dart';
import 'package:legacyhub/core/utils/helpers/svg_icon_helper.dart';

class BuildNextButton extends StatelessWidget {
  const BuildNextButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50.w,
        height: 50.h,
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0095FF), Color(0xFF92BFF3)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: SvgIconHelper.buildIcon(
          assetPath: SvgPath.arrowLineRight,
          size: 28.w,
        ),
      ),
    );
  }
}
