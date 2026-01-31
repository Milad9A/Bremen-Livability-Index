import 'package:flutter/material.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

class SafeLiquidGlassView extends StatelessWidget {
  final Widget backgroundWidget;
  final List<LiquidGlass> children;

  static bool useMock = false;

  const SafeLiquidGlassView({
    super.key,
    required this.backgroundWidget,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    if (useMock) {
      return Stack(
        children: [
          backgroundWidget,
          ...children.map((glass) {
            double? left, top, right, bottom;
            if (glass.position is LiquidGlassOffsetPosition) {
              final pos = glass.position as LiquidGlassOffsetPosition;
              left = pos.left;
              top = pos.top;
            }
            return Positioned(
              left: left,
              top: top,
              right: right,
              bottom: bottom,
              width: glass.width,
              height: glass.height,
              child: glass.child ?? const SizedBox(),
            );
          }),
        ],
      );
    }

    return LiquidGlassView(
      backgroundWidget: backgroundWidget,
      children: children,
    );
  }
}
