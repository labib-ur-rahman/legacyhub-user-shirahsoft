import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project_template/core/common/widgets/shimmers/shimmer.dart';
import 'package:project_template/core/utils/constants/colors.dart';
import 'package:project_template/core/utils/constants/sizes.dart';
import 'package:project_template/core/utils/helpers/app_helper.dart';

class AppCircularImage extends StatelessWidget {
  const AppCircularImage({
    super.key,
    this.width = 56,
    this.height = 56,
    this.overlayColor,
    this.backgroundColor,
    required this.image,
    this.fit = BoxFit.cover,
    this.padding = AppSizes.sm,
    this.isNetworkImage = false,
    this.onPressed,
  });

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final dark = AppHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          // If image background color is null then switch it to light and dark mode color design.
          color: backgroundColor ?? (dark ? AppColors.black : AppColors.white),
          borderRadius: BorderRadius.circular(100),
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Center(
            child: isNetworkImage
                ? CachedNetworkImage(
                    fit: fit,
                    color: overlayColor,
                    imageUrl: image,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            AppShimmerEffect(width: 55, height: 55, radius: 55),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
                : Image(
                    fit: fit,
                    image: AssetImage(image),
                    color: overlayColor,
                  ),
          ),
        ),
      ),
    );
  }
}