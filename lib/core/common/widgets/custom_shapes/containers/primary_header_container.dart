import 'package:flutter/material.dart';
import 'package:legacyhub/core/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:legacyhub/core/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:legacyhub/core/utils/constants/colors.dart';


class SLPrimaryHeaderContainer extends StatelessWidget {
  const SLPrimaryHeaderContainer({
    super.key, required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SLCurvedEdgeWidget(
      child: Container(
        color: AppColors.primary,
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Positioned(top: -150, right: -250, child: SLCircularContainer(backgroundColor: AppColors.textWhite.withValues(alpha: 0.1),),),
            Positioned(top: 100, right: -300, child: SLCircularContainer(backgroundColor: AppColors.textWhite.withValues(alpha: 0.1),),),
            child,
          ],
        ),
      ),
    );
  }
}