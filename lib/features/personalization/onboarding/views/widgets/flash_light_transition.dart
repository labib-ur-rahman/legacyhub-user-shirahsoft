import 'package:flutter/material.dart';

/// ============================================================================
/// FLASH LIGHT TRANSITION
/// ============================================================================
/// A subtle flash/light overlay effect during page transitions.
/// Creates a premium "flash" feel when swiping between pages.
///
/// Features:
/// - Listens to PageController scroll position
/// - Shows a brief white flash overlay at peak transition
/// - Lightweight — only triggers during active scroll
/// - Zero performance impact when idle
/// ============================================================================

class FlashLightTransition extends StatefulWidget {
  final PageController pageController;

  const FlashLightTransition({super.key, required this.pageController});

  @override
  State<FlashLightTransition> createState() => _FlashLightTransitionState();
}

class _FlashLightTransitionState extends State<FlashLightTransition> {
  double _flashOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!widget.pageController.hasClients) return;

    final page = widget.pageController.page ?? 0.0;
    // Calculate how far between two pages (0.0 = on a page, 0.5 = halfway)
    final fraction = page - page.floor();
    // Peak flash at 0.5 (midpoint between pages)
    // Sine curve for smooth in/out: peaks at 0.5, zero at 0.0 and 1.0
    final sinValue = (fraction * 3.14159).clamp(0.0, 3.14159);
    final flash = (sinValue > 0 && sinValue < 3.14159)
        ? (0.08 * _sinApprox(sinValue))
        : 0.0;

    if (mounted) {
      setState(() {
        _flashOpacity = flash;
      });
    }
  }

  /// Simple sine approximation for performance
  double _sinApprox(double x) {
    // Normalize to [0, PI]
    final normalized = x / 3.14159;
    // Parabolic approximation of sin: 4 * x * (1 - x) for x in [0, 1]
    return 4 * normalized * (1 - normalized);
  }

  @override
  Widget build(BuildContext context) {
    if (_flashOpacity <= 0.001) return const SizedBox.shrink();

    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: _flashOpacity,
        duration: const Duration(milliseconds: 50),
        child: Container(color: Colors.white),
      ),
    );
  }
}
