import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';

class AnimatedToggleSelector extends StatefulWidget {
  final String leftOption;
  final String rightOption;
  final int selectedIndex; // 0 for left, 1 for right
  final Function(int) onToggle;
  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final double height;
  final double width;

  const AnimatedToggleSelector({
    super.key,
    required this.leftOption,
    required this.rightOption,
    required this.selectedIndex,
    required this.onToggle,
    this.selectedColor = Colors.white,
    this.unselectedColor = Colors.black,
    this.selectedTextColor = Colors.black,
    this.unselectedTextColor = Colors.white,
    this.height = 56,
    this.width = 340,
  });

  @override
  State<AnimatedToggleSelector> createState() => _AnimatedToggleSelectorState();
}

class _AnimatedToggleSelectorState extends State<AnimatedToggleSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width.w,
      height: widget.height.h,
      decoration: BoxDecoration(
        color: widget.unselectedColor,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: widget.unselectedColor, width: 2.w),
      ),
      child: Stack(
        children: [
          // Animated sliding selector
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: widget.selectedIndex == 0 ? 4.w : (widget.width / 2.15).w,
            top: 4.h,
            bottom: 4.h,
            child: Container(
              width: (widget.width / 2 - 8).w,
              decoration: BoxDecoration(
                color: widget.selectedColor,
                borderRadius: BorderRadius.circular(24.r),
              ),
            ),
          ),

          // Options
          Row(
            children: [
              // Left option
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.onToggle(0),
                  child: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: getLabelTextStyle().copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: widget.selectedIndex == 0
                              ? widget.selectedTextColor
                              : widget.unselectedTextColor,
                        ),
                        child: Text(widget.leftOption),
                      ),
                    ),
                  ),
                ),
              ),

              // Right option
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.onToggle(1),
                  child: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: getLabelTextStyle().copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: widget.selectedIndex == 1
                              ? widget.selectedTextColor
                              : widget.unselectedTextColor,
                        ),
                        child: Text(widget.rightOption),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
