import 'package:flutter/material.dart';
import 'package:legacyhub/core/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:legacyhub/core/utils/constants/sizes.dart';
import 'package:legacyhub/core/utils/device/device_utility.dart';
import 'package:legacyhub/core/utils/helpers/app_helper.dart';

class SLSearchContainer extends StatelessWidget {
  const SLSearchContainer({
    super.key,
    required this.text,
    this.icon = Iconsax.search_normal,
    this.showBackground = true,
    this.showBorder = true,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace),
  });

  final String text;
  final IconData? icon;
  final bool showBackground, showBorder;
  final VoidCallback? onTap; // Noted
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final dark = AppHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Container(
          width: AppDeviceUtils.getScreenWidth(context),
          padding: const EdgeInsets.all(AppSizes.sm),
          decoration: BoxDecoration(
            color: showBackground
                ? dark
                      ? AppColors.dark
                      : AppColors.light
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.sm),
            border: showBorder ? Border.all(color: AppColors.grey) : null,
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.darkerGrey),
              const SizedBox(width: AppSizes.sm),
              Text(text, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
