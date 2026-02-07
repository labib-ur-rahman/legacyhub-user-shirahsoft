import 'package:flutter/material.dart';
import 'package:legacyhub/core/utils/constants/colors.dart';
import 'package:legacyhub/core/utils/helpers/app_helper_functions.dart';

class AppShimmerEffect extends StatelessWidget {
  const AppShimmerEffect({
    super.key,
    required this.width,
    required this.height,
    this.radius = 15,
    this.color,
  });

  final double width, height, radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final dark = AppHelperFunctions.isDarkMode(context);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? (dark ? AppColors.darkerGrey : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
