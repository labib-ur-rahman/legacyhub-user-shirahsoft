import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// LegacyHub brand logo with styled text using Google Fonts K2D
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'LegacyHub',
      style: GoogleFonts.k2d(
        fontWeight: FontWeight.w800,
        fontSize: 28.sp,
        color: Colors.white,
        height: 1.0,
      ),
    );
  }
}
