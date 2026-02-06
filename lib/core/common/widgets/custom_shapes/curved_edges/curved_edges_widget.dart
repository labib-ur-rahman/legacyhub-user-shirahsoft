import 'package:flutter/material.dart';
import 'package:legacyhub/core/common/widgets/custom_shapes/curved_edges/curved_edges.dart';

/// Curved Edge Widget - Wraps a child widget with curved bottom edges
///
/// Usage:
///   SLCurvedEdgeWidget(
///     cornerRadius: 30,
///     child: Container(
///       decoration: BoxDecoration(gradient: myGradient),
///     ),
///   )
class SLCurvedEdgeWidget extends StatelessWidget {
  const SLCurvedEdgeWidget({super.key, this.child, this.cornerRadius = 30.0});

  /// The widget to wrap with curved edges
  final Widget? child;

  /// Corner radius for bottom curves (default: 30.0)
  final double cornerRadius;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: SLCustomCurvedEdges(cornerRadius: cornerRadius),
      child: child,
    );
  }
}
