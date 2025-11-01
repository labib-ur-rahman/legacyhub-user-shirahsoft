import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_template/core/utils/constants/colors.dart';

/// -- Normal Text
TextStyle getTextStyle({
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.w400,
  double lineHeight = 1.20,
  TextAlign textAlign = TextAlign.start,
  Color color = AppColors.dark,
}) {
  return GoogleFonts.inter(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    height: lineHeight.h,
    color: color,
  );
}

/// -- Bold Text
TextStyle getBoldTextStyle({
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.w600,
  double lineHeight = 1.20,
  TextAlign textAlign = TextAlign.start,
  Color color = AppColors.dark,
}) {
  return GoogleFonts.inter(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    height: lineHeight.h,
    color: color,
  );
}

/// -- Heading Text
TextStyle getHeadingStyle({
  double fontSize = 24.0,
  FontWeight fontWeight = FontWeight.w600,
  double lineHeight = 1.20,
  TextAlign textAlign = TextAlign.start,
  Color color = AppColors.dark,
  FontStyle fontStyle = FontStyle.normal,
}) {
  return GoogleFonts.inter(
    fontStyle: fontStyle,
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    height: lineHeight.h,
    color: color,
  );
}

/// -- SubHeading Text
TextStyle getSubHeadingStyle({
  double fontSize = 16.0,
  FontWeight fontWeight = FontWeight.w400,
  double lineHeight = 1.60,
  TextAlign textAlign = TextAlign.start,
  Color color = AppColors.dark,
}) {
  return GoogleFonts.inter(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    height: lineHeight.h,
    color: color,
  );
}

/// -- Label Text
TextStyle getLabelTextStyle({
  double fontSize = 16.0,
  FontWeight fontWeight = FontWeight.w400,
  double lineHeight = 1.60,
  TextAlign textAlign = TextAlign.start,
  Color color = AppColors.dark,
}) {
  return GoogleFonts.inter(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    height: lineHeight.h,
    color: color,
  );
}