import 'package:flutter/material.dart';

/// Custom Curved Edges Clipper for App Bar
/// Creates a smooth curved bottom edge similar to Figma design
///
/// The curve creates a rounded bottom with symmetrical corners
/// matching the LegacyHub app bar design.
class SLCustomCurvedEdges extends CustomClipper<Path> {
  /// Corner radius for the bottom left and right corners
  final double cornerRadius;

  /// Constructor with configurable corner radius
  SLCustomCurvedEdges({this.cornerRadius = 30.0});

  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from top-left corner
    path.moveTo(0, 0);

    // Draw line to bottom-left, but stop before the curve starts
    path.lineTo(0, size.height - cornerRadius);

    // Bottom-left corner curve
    path.quadraticBezierTo(0, size.height, cornerRadius, size.height);

    // Draw line across the bottom (between the two curves)
    path.lineTo(size.width - cornerRadius, size.height);

    // Bottom-right corner curve
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width,
      size.height - cornerRadius,
    );

    // Draw line to top-right corner
    path.lineTo(size.width, 0);

    // Close the path back to start
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    if (oldClipper is SLCustomCurvedEdges) {
      return oldClipper.cornerRadius != cornerRadius;
    }
    return true;
  }
}
