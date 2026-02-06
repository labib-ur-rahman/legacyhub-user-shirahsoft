import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legacyhub/core/utils/constants/colors.dart';

/// -- Normal Text
TextStyle getTextStyle({
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.w400,
  double lineHeight = 1.20,
  TextAlign textAlign = TextAlign.start,
  Color color = AppColors.dark,
}) {
  return GoogleFonts.hindSiliguri(
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
  return GoogleFonts.hindSiliguri(
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
  return GoogleFonts.hindSiliguri(
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
  return GoogleFonts.hindSiliguri(
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
  return GoogleFonts.hindSiliguri(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    height: lineHeight.h,
    color: color,
  );
}

/// -- K2D Bold Text (Premium Heading Font)
/// Used for: App bar titles, premium headings, brand elements
TextStyle getK2DTextStyle({
  double fontSize = 24.0,
  FontWeight fontWeight = FontWeight.w700,
  double lineHeight = 1.20,
  TextAlign textAlign = TextAlign.start,
  Color color = AppColors.dark,
}) {
  return GoogleFonts.k2d(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    height: lineHeight.h,
    color: color,
  );
}

/// -- Imperial Script Text (Decorative Font)
/// Used for: Brand logo, fancy headers, decorative elements
TextStyle getImperialScriptTextStyle({
  double fontSize = 28.0,
  FontWeight fontWeight = FontWeight.w400,
  double lineHeight = 1.20,
  TextAlign textAlign = TextAlign.start,
  Color color = AppColors.dark,
  FontStyle fontStyle = FontStyle.normal,
}) {
  return GoogleFonts.imperialScript(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    height: lineHeight.h,
    color: color,
    fontStyle: fontStyle,
  );
}
