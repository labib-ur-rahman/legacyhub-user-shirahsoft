import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:legacyhub/core/common/styles/global_text_style.dart';

class MaterialTabSelector extends StatefulWidget {
  final String leftOption;
  final String rightOption;
  final int selectedIndex; // 0 for left, 1 for right
  final Function(int) onToggle;
  final double height;
  final double width;
  final Color backgroundColor;
  final Color indicatorColor;

  const MaterialTabSelector({
    super.key,
    required this.leftOption,
    required this.rightOption,
    required this.selectedIndex,
    required this.onToggle,
    this.height = 56,
    this.width = 340,
    this.backgroundColor = Colors.black,
    this.indicatorColor = Colors.white,
  });

  @override
  State<MaterialTabSelector> createState() => _MaterialTabSelectorState();
}

class _MaterialTabSelectorState extends State<MaterialTabSelector>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.selectedIndex,
    );
  }

  @override
  void didUpdateWidget(MaterialTabSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _tabController.animateTo(widget.selectedIndex);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width.w,
      height: widget.height.h,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(28.r),
      ),
      child: TabBar(
        padding: EdgeInsets.all(4.w),
        controller: _tabController,
        dividerColor: Colors.transparent,
        onTap: (index) {
          widget.onToggle(index);
        },
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: widget.indicatorColor,
          borderRadius: BorderRadius.circular(24.r),
        ),
        labelColor: Colors.black,
        unselectedLabelColor: Colors.white,
        labelStyle: getTextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          lineHeight: 2,
        ),
        unselectedLabelStyle: getTextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          lineHeight: 2,
        ),
        tabs: [
          Tab(text: widget.leftOption),
          Tab(text: widget.rightOption),
        ],
      ),
    );
  }
}
