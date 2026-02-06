import 'package:flutter/material.dart';
import 'package:legacyhub/core/utils/constants/colors.dart';

class AppCircularLoader extends StatelessWidget {
  final double size;

  const AppCircularLoader({super.key, this.size = 60});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [AppColors.success, Color(0xFF81C784)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.greenAccent.withValues(alpha: 0.4),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: CircularProgressIndicator(strokeWidth: 4, color: Colors.white),
        ),
      ),
    );
  }
}
