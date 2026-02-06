import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:legacyhub/core/utils/constants/sizes.dart';
import 'package:legacyhub/core/utils/device/device_utility.dart';
import 'package:legacyhub/core/utils/helpers/app_helper.dart';
import '../../../utils/constants/colors.dart';

class SLAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SLAppBar({
    super.key,
    this.title,
    this.actions,
    this.leadingIcon,
    this.leading0nPressed,
    this.showBackArrow = false,
  });

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leading0nPressed;

  @override
  Widget build(BuildContext context) {
    final dark = AppHelperFunctions.isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
      child: AppBar(
        automaticallyImplyLeading: false,
        leading: showBackArrow
            ? IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Iconsax.arrow_left,
                  color: dark ? AppColors.light : AppColors.dark,
                ),
              )
            : leadingIcon != null
            ? IconButton(onPressed: leading0nPressed, icon: Icon(leadingIcon))
            : null,
        title: title,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppDeviceUtils.getAppBarHeight());
}
