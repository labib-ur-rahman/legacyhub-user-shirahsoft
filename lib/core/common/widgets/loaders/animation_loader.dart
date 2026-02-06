import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:legacyhub/core/utils/constants/colors.dart';
import 'package:legacyhub/core/utils/constants/sizes.dart';

/// Lottie Animation
/// A widget for displaying an animated loading indicator with optional text and action button.
class AppAnimationLoaderWidget extends StatelessWidget {
  /// Default constructor for the AppAnimationLoaderWidget.
  ///
  /// Parameters:
  ///   -  text: The text to be displayed below the animation.
  ///   -  animation: The path to the Lottie animation file.
  ///   -  showAction: Whether to show an action button below the text.
  ///   -  actionText: The text to be displayed on the action button.
  ///   -  onActionPressed: Callback function to be executed when the action button is pressed.
  const AppAnimationLoaderWidget({
    super.key,
    required this.text,
    required this.animation,
    this.showAction = false,
    this.actionText,
    this.onActionPressed,
    this.lottieWidth = 0.8,
  });

  final String text;
  final String animation;
  final bool showAction;
  final double lottieWidth;
  final String? actionText;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            animation,
            width: MediaQuery.of(context).size.width * lottieWidth,
          ), // Display Lottie animation
          const SizedBox(height: AppSizes.defaultSpace),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.defaultSpace),
          showAction
              ? SizedBox(
                  width: 250,
                  child: OutlinedButton(
                    onPressed: onActionPressed,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.dark,
                    ),
                    child: Text(
                      actionText!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.apply(color: AppColors.light),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
