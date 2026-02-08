import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';
import 'package:legacyhub/core/localization/app_string_localizations.dart';
import 'package:legacyhub/core/utils/constants/app_style_colors.dart';
import 'package:legacyhub/features/personalization/onboarding/controllers/style_controller.dart';
import 'package:legacyhub/features/personalization/onboarding/views/widgets/build_next_button.dart';

/// Style Selection Screen - Onboarding screen for choosing app style
/// Allows users to choose between 6 different app color styles
class StyleScreen extends StatelessWidget {
  const StyleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StyleController());
    final isDark = Get.isDarkMode;
    final bgColor = isDark ? const Color(0xFF1A1A2E) : const Color(0xFFEEEFFC);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      color: bgColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),

                // Preview App Bar with current style
                _buildPreviewAppBar(controller),

                SizedBox(height: 32.h),

                // Title
                _buildTitle(),

                SizedBox(height: 12.h),

                // Subtitle
                _buildSubtitle(isDark),

                SizedBox(height: 32.h),

                // Style Grid
                Expanded(child: _buildStyleGrid(controller)),

                SizedBox(height: 16.h),

                // Next Button
                BuildNextButton(onTap: () => controller.skipStyleSelection()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build preview app bar showing current style gradient
  Widget _buildPreviewAppBar(StyleController controller) {
    return Obx(() {
      // Access the observable to trigger rebuild
      final style = controller.selectedStyle.value;
      final gradient = controller.getPreviewGradient(style);
      final primaryColor = AppStyleColors.instance.primary;

      return Container(
        width: double.infinity,
        height: 80.h,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'LegacyHub',
                style: TextStyle(
                  fontFamily: 'K2D',
                  fontWeight: FontWeight.w800,
                  fontSize: 24.sp,
                  color: Colors.white,
                ),
              ),
              Container(
                height: 14.h,
                width: 1.w,
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                color: Colors.white.withValues(alpha: 0.5),
              ),
              Text(
                AppStrings.homeTitle,
                style: TextStyle(
                  fontFamily: 'Imperial Script',
                  fontSize: 18.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// Build gradient title
  Widget _buildTitle() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFF38B3FF), Color(0xFF0031FF)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bounds),
      child: Text(
        AppStrings.chooseStyle,
        style: getBoldTextStyle(fontSize: 24, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Build subtitle description
  Widget _buildSubtitle(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        AppStrings.chooseStyleSubtitle,
        style: getTextStyle(
          fontSize: 15,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Build style selection grid (2 columns, 3 rows)
  Widget _buildStyleGrid(StyleController controller) {
    return Obx(() {
      // Access the observable to trigger rebuild when selection changes
      final currentStyle = controller.selectedStyle.value;

      return GridView.builder(
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 1.5,
        ),
        itemCount: controller.allStyles.length,
        itemBuilder: (context, index) {
          final style = controller.allStyles[index];
          return _StyleCard(
            style: style,
            styleName: controller.getStyleName(style),
            gradient: controller.getPreviewGradient(style),
            isSelected: style == currentStyle,
            onTap: () => controller.selectStyle(style),
          );
        },
      );
    });
  }
}

/// Style Card Widget - Individual style option card
class _StyleCard extends StatelessWidget {
  const _StyleCard({
    required this.style,
    required this.styleName,
    required this.gradient,
    required this.isSelected,
    required this.onTap,
  });

  final AppStyle style;
  final String styleName;
  final LinearGradient gradient;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16.r),
          border: isSelected
              ? Border.all(color: Colors.white, width: 3.w)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: gradient.colors.first.withValues(alpha: 0.5),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Stack(
          children: [
            // Style Name
            Center(
              child: Text(
                styleName,
                style: getBoldTextStyle(fontSize: 18, color: Colors.white),
              ),
            ),

            // Selected Indicator
            if (isSelected)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Container(
                  width: 24.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check,
                    size: 16.sp,
                    color: gradient.colors.last,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
